MovieMaker mm;
boolean recordMovie = false;
String movieName = "FlaneursTrace.mov";

void setupMovieMaker() {
  if (recordMovie) {
    mm = new MovieMaker(this, width, height, movieName, 30, MovieMaker.H263, MovieMaker.HIGH);
  }
}
