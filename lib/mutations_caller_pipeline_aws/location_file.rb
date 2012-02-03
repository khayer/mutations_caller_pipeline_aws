class LocationFile
  def self.create(vcf_file, loction_file_output)
    locations = File.open(vcf_file)
    line = locations.readline()

    locus = []
    while line.include?('#')
      location = line.scan(/##contig=<ID=+\w+/)
      if !location.empty?()
        location = location[0].split('=')
        locus << location[-1]
      end
      line = locations.readline()
    end

    locations.close()
    locus_file = File.new(location_file_output,'w')
    locus_file.write(locus.join("\n"))
    locus_file.close()
  end
end