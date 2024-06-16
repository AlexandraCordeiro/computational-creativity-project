class ReadMusicData {

    // Define arrays to store the feature data for all songs
    ArrayList<float[]> amplitudeList = new ArrayList<float[]>();
    ArrayList<float[]> frequencyList = new ArrayList<float[]>();
    ArrayList<float[]> zeroCrossingRateList = new ArrayList<float[]>();
    ArrayList<float[]> spectralBandwidthList = new ArrayList<float[]>();
    ArrayList<float[]> spectralContrastList = new ArrayList<float[]>();
    ArrayList<float[]> rmseList = new ArrayList<float[]>();

    // Define the number of slices
    int numSlices = 360;

    ReadMusicData() {
        println("*****");
        JSONObject data = loadJSONObject("../outputData/sound_data.json");
  
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
  
        /* println("Amplitude of Song 1:");
        printArray(amplitudeList.get(0));
        println("Amplitude of Song 2:");
        printArray(amplitudeList.get(1));
        println("Amplitude of Song 3:");
        printArray(amplitudeList.get(2)); */
    }

    float[] extractFeatureArray(JSONObject song, String featureName) {
        JSONArray array = song.getJSONArray(featureName);
        if (array != null) {
            float[] featureArray = new float[numSlices];
            for (int i = 0; i < numSlices; i++) {
                featureArray[i] = array.getFloat(i);
            }
        return featureArray;
        } else {
            println("Feature array '" + featureName + "' not found in song data.");
            return null;
        }
    }
}