class UserJob < ActiveJob::Base
  queue_as :default

  rescue_from(StandardError) do |ex|
  #TODO Right now, should catch each error
  puts "[Job: #{self.job_id}] I failed! Script is okay, please check Rails code or server."
  puts ex.inspect
  this_job = JobMonitor.find_by(job_id: self.job_id)
  this_job.update(status: "failed")
  end

  def perform(*args)
    puts "[Job: #{self.job_id}]: I'm performing my job with arguments: #{args.inspect}"

    user = args[0]["user"]
    @userdir = File.dirname("#{Rails.root}/user/#{user}/#{self.job_id}/.to_path")
    modelscript = args[0]["model"]
    @originaldir = File.dirname(modelscript)
    @symlinkmodel = @userdir.to_s + "/" + File.basename(modelscript)
    @project = UserProject.find_by(job_id: self.job_id)

    #TODO Add handling and passing of arguments
    @arg1, @arg2 = "arg1", "arg2"


    create_tmpdir_with_symlinks

    script_status = execute_script
    puts "Script status"
    puts script_status
    @return_val = 0

    @project.output = {stdout: @stdout, stderr: @stderr}
    @project.save

    delete_symlinks

    @project.resultfiles = Dir.glob(Rails.root.join(@userdir, '*'))
    @project.save

    zip_result_files

  end

  around_perform do |job, block|
    puts "[Job: #{self.job_id}] Before performing ..."
    this_job = JobMonitor.find_by(job_id: self.job_id)
    this_job.update(status: "running")
    block.call
    if @return_val != 0
      puts "[Job: #{self.job_id}] I failed. The script has an exit value of #{@return_val}."
      this_job.update(status: "failed")
    else
      puts "[Job: #{self.job_id}] I successfully finished my job."
      this_job.update(status: "failed")
    end
  end

  around_enqueue do |job, block|
    args = job.arguments[0]
    puts "[Job: #{self.job_id}] Before enqueing ... "
    JobMonitor.create(job_id: self.job_id, user: args["user"], status: "waiting")
    block.call
    puts "[Job: #{self.job_id}] After enqueing ..."
  end

  def zip_result_files
    ## Now, create a zipped archive of all resultfiles, if there are any
    require 'zip'
    zipfile_name = @userdir + "/all-resultfiles-#{@project.name}.zip"
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      @project.resultfiles.each do |resultfile|
        zipfile.add(File.basename(resultfile), resultfile)
      end
    end
  end

  def delete_symlinks
    # Cleans up symlinks after processing a job
    modelfiles = Dir.glob(@originaldir + "/*")
    modelfiles.each do |modelfile|
      symlink = @userdir.to_s + '/' + File.basename(modelfile)
      File.delete(symlink)
    end
  end

  def execute_script
    ### Go to the temporary working directory and execute the script
    #TODO for mf script, not the entire stdout and stderr is retrieved
    Dir.chdir(@userdir) do
      Open3.popen3(@symlinkmodel, @arg1 + " " + @arg2) do |stdin, stdout, stderr, thread|
        stdin.close  # make sure the subprocess is done
        @stdout = stdout.gets
        @stderr = stderr.gets
        thread.value # Return value
      end
    end
  end

  def create_tmpdir_with_symlinks
    ### Create a tmp user dir and symlinks for model files
    FileUtils.mkdir_p(@userdir) unless File.directory?(@userdir)

    modelfiles = Dir.glob(@originaldir + "/*")
    modelfiles.each do |modelfile|
      symlink = @userdir.to_s + '/' + File.basename(modelfile)
      `ln -sf #{modelfile} #{symlink}`
    end
  end



end
