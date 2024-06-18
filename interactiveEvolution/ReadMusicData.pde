class ReadMusicData {

    // Define arrays to store the feature data for all songs
    ArrayList<float[][]> amplitudeList = new ArrayList<float[][]>();
    ArrayList<float[][]> frequencyList = new ArrayList<float[][]>();
    ArrayList<float[][]> zeroCrossingRateList = new ArrayList<float[][]>();
    ArrayList<float[][]> spectralBandwidthList = new ArrayList<float[][]>();
    ArrayList<float[][]> spectralContrastList = new ArrayList<float[][]>();
    ArrayList<float[][]> rmseList = new ArrayList<float[][]>();


    // Define the number of slices
    int numCircles = 361;
    int numLayers = 20;
    int numSlices = numCircles * numLayers;

    ReadMusicData() {
        println("*****");
        JSONObject data = loadJSONObject("./outputData/sound_data.json");
  
        // Iterate over each song
        for (int i = 1; i <= 3; i++) {
            // Extract song object
            JSONObject song = data.getJSONObject("song" + i);
            
            // Extract feature arrays for the current song
            amplitudeList.add(extractFeatureArray(song, "amplitude"));
            frequencyList.add(extractFeatureArray(song, "frequency"));
            zeroCrossingRateList.add(extractFeatureArray(song, "zero_crossing_rate"));
            spectralBandwidthList.add(extractFeatureArray(song, "spectral_bandwidth"));
            spectralContrastList.add(extractFeatureArray(song, "spectral_contrast"));
            rmseList.add(extractFeatureArray(song, "rmse"));
        }

        //println("Amplitude of Song 1:");
        //print2DArray(amplitudeList.get(0));
     
    }

    float[][] extractFeatureArray(JSONObject song, String featureName) {
        JSONArray originalArray = song.getJSONArray(featureName);
        if (originalArray != null) {
            float[][] featureArray =new float[numLayers][numCircles];

            // Transform the 1D array into a 2D array
            int index = 0;
            for (int i = 0; i < 20; i++) {
              for (int j = 0; j < 361; j++) {
                  if (index < originalArray.size()) {
                      featureArray[i][j] = originalArray.getFloat(index++);
                  }
              }
            }
        return featureArray;
        }
        else {
            println("Feature array '" + featureName + "' not found in song data.");
            return null;
        }
    }

    // Function to print a 2D array
    void print2DArray(float[][] array) {
    for (int i = 0; i < array.length; i++) {
        for (int j = 0; j < array[i].length; j++) {
        print(array[i][j] + " ");
        }
        println();
    }
    }
}
