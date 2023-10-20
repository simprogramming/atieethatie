# Default policies when a model is available for admin only
module AdminBasePolicy
  extend ActiveSupport::Concern

  included do |klass|
    # rubocop:disable Lint/ConstantDefinitionInBlock, Style/ClassAndModuleChildren
    class klass::Scope < klass::Scope
      def resolve
        scope.all if user.admin?
      end
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock, Style/ClassAndModuleChildren

    def index?
      user.admin?
    end

    def show?
      user.admin?
    end

    def create?
      user.admin?
    end

    def new?
      user.admin?
    end

    def update?
      user.admin?
    end

    def edit?
      user.admin?
    end

    def destroy?
      user.admin?
    end
  end
end
