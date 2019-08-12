Puppet::Type.newtype(:httpauth) do
    @doc = "Manage HTTP Basic or Digest password files." +
           "    httpauth { 'name':                     " +
           "      username => user                     " +
           "      file => '/path/to/password/file',    " +
           "      password => 'password',              " +
           "      mechanism => basic,                  " +
           "      ensure => present,                   " +
           "    }                                      "
 
    ensurable do
       newvalue(:present) do
           provider.create
       end

       newvalue(:absent) do
           provider.destroy
       end

       defaultto :present
    end

    newparam(:name) do
       desc "The name of the user to be managed."

       isnamevar
    end 

    newparam(:username) do
       desc "The name of the user to be managed."

       defaultto { @resource[:name] }
    end 

    newparam(:file) do
       desc "The HTTP password file to be managed. If it doesn't exist it is created."
    end

    newparam(:password) do
       desc "The password in plaintext."
    
    end

    newparam(:realm) do
       desc "The realm - defaults to nil and mainly used for Digest authentication."

       defaultto "nil"
    end
    
    newparam(:mechanism) do
       desc "The authentication mechanism to use - either basic or digest. Default to basic."
       
       newvalues(:basic, :digest)
      
       defaultto :basic
    end

    # Ensure a password is always specified
    validate do
       raise Puppet::Error, "You must specify a password for the user." unless @parameters.include?(:password)
    end

    newparam(:owner) do
      desc "The owner of the file"
    end

    newparam(:group) do
      desc "The group owner of the file"
    end

    newparam(:mode) do
      desc "The file mode. Default to 0600"
      defaultto '0600'
    end

    def generate
      file_opts = {
        ensure: :file
      }
      file_opts[:name] = self[:file]
      file_opts[:owner] = self[:owner] unless self[:owner].nil?
      file_opts[:group] = self[:group] unless self[:group].nil?
      file_opts[:mode] = self[:mode] unless self[:mode].nil?
      file_opts[:require] = "Httpauth[#{self[:name]}]"
      [Puppet::Type.type(:file).new(file_opts)]
    end
end
