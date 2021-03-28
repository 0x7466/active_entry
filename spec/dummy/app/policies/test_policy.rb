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
  end
end
