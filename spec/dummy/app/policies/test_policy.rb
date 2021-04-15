module TestPolicy
  class Authentication < ActiveEntry::Base::Authentication
    def unauthenticated?
      false
    end

    def authenticated_unauthorized?
      success
    end

    def authenticated_authorized?
      success
    end

    def authenticated_authorized_with_arg?
      #@arg.present?
    end
  end

  class Authorization < ActiveEntry::Base::Authorization
    def unauthenticated?
      false
    end

    def authenticated_unauthorized?
      false
    end

    def authenticated_authorized?
      success
    end

    def authenticated_authorized_with_arg?
      @arg.present?
    end
  end
end
