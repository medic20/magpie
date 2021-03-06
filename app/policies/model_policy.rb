class ModelPolicy < ApplicationPolicy

  def create?
    !user.nil? && (user.admin || user.right.model_add)
  end

  def new?
    !user.nil? && (user.admin || user.right.model_add)
  end

  def reupload?
    !user.nil? && (record.user == user || user.admin?)
  end

  def update?
    !user.nil? && (record.user == user || user.admin?)
  end

  def edit?
    !user.nil? && (record.user == user || user.admin?)
  end

  def destroy?
    !user.nil? && (record.user == user || user.admin? || user.right.model_delete)
  end

  def download?
    !user.nil?
  end

  def show?
    !user.nil?
  end

  def show_logo?
    !user.nil?
  end

  def index?
    !user.nil?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
