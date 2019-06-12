class WayFinder

  def initialize options
    @start_airport = options[:from]
    @end_airport = options[:to]
    @transfers = options[:transfers].to_i
    @path = options[:path] || './routes.dat'
    @routes = []
  end

  def routes
    #pretty output
    unless @routes.empty?
      @routes.each do |route|
        p route
      end
    else
      puts 'No possible routes found. Please check if airports are correct.'
    end
  end

  def get_all_flights_from(airport)
    IO.foreach(@path).grep(Regexp.new ('^\w{2,3},\d*,' + airport))
  end

  def get_all_destinations_from(airport)
    all_flights = get_all_flights_from(airport)
    all_flights.map{|flight| flight.split(',')[4]}.uniq
  end

  def scan(airport=@start_airport, k=0, route=[])
    destinations = get_all_destinations_from(airport)
    # save current route if end airport is found
    @routes.push([*route, airport, @end_airport]) if destinations.include?(@end_airport)
    return nil if k == @transfers
    destinations.each do |next_airport|
      # scan all destination airports, loops are filtered
      self.scan(next_airport, k+1, [*route, airport]) unless route.include?(next_airport)
    end
  end

end