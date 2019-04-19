Facter.add('maas_secret') do
  setcode do
    if File.exist? '/var/lib/maas/secret'
      Facter::Core::Execution.execute('/bin/cat /var/lib/maas/secret')
    end
  end
end
