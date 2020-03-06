# Simple class to provide mappings between key stages and school
# years, based on the data at:
#
# https://www.gov.uk/national-curriculum
#
# | Age      | Year        | Key stage   |
# |----------|-------------|-------------|
# | 3 to 4   | Early years | N/A         |
# | 4 to 5   | Reception   | Early years |
# | 5 to 6   | Year 1      | KS1         |
# | 6 to 7   | Year 2      | KS1         |
# | 7 to 8   | Year 3      | KS2         |
# | 8 to 9   | Year 4      | KS2         |
# | 9 to 10  | Year 5      | KS2         |
# | 10 to 11 | Year 6      | KS2         |
# | 11 to 12 | Year 7      | KS3         |
# | 12 to 13 | Year 8      | KS3         |
# | 13 to 14 | Year 9      | KS3         |
# | 14 to 15 | Year 10     | KS4         |
# | 15 to 16 | Year 11     | KS4         |
class SchoolYear
  include Singleton

  MAPPING = { 1 => 1..2, 2 => 3..6, 3 => 7..9, 4 => 10..11 }.freeze

  def years
    MAPPING.values.flat_map(&:to_a)
  end

  def key_stages
    MAPPING.keys
  end

  def years_at(key_stage:)
    MAPPING.fetch(key_stage).to_a
  end

  def key_stage_for(year:)
    MAPPING.each { |key_stage, range| return key_stage if range.include?(year) }
  end
end
