class ReadMusicData {
    // Define arrays to store the feature data for all songs
    ArrayList<float[][]> amplitudeList = new ArrayList<float[][]>();
    ArrayList<float[][]> frequencyList = new ArrayList<float[][]>();
    ArrayList<float[][]> zeroCrossingRateList = new ArrayList<float[][]>();
    ArrayList<float[][]> spectralBandwidthList = new ArrayList<float[][]>();
    ArrayList<float[][]> spectralContrastList = new ArrayList<float[][]>();
    ArrayList<float[][]> mfccList = new ArrayList<float[][]>();
    ArrayList<float[][]> rmseList = new ArrayList<float[][]>();
    ArrayList<Integer> durationList = new ArrayList<Integer>();
    ArrayList<Integer> bpmList = new ArrayList<Integer>();
    ArrayList<Integer> spectralMax = new ArrayList<Integer>();;
    ArrayList<Integer> spectralMin = new ArrayList<Integer>();;
    ArrayList<Integer> mfccMax = new ArrayList<Integer>();
    ArrayList<Integer> mfccMin = new ArrayList<Integer>();
    ArrayList<String> musicPath = new ArrayList<String>();


    // Define the number of slices
    int numCircles = 361;
    int numLayers = 20;
    int numSlices = numCircles * numLayers;

    ReadMusicData() {
        JSONObject data = loadJSONObject("./outputData/sound_data.json");
  
        // Iterate over each song
        for (int i = 0; i <= 2; i++) {       
            JSONObject song = data.getJSONObject("song" + i);
            durationList.add(extractSingleFeature(song,"duration"));
            bpmList.add(extractSingleFeature(song,"bpm"));
            mfccList.add(extractFeatureArray(song, "mfcc"));
            amplitudeList.add(extractFeatureArray(song, "amplitude"));
            spectralBandwidthList.add(extractFeatureArray(song, "spectral_bandwidth"));
            spectralMax.add(extractSingleFeature(song,"spectral_bandwidth_max"));
            spectralMin.add(extractSingleFeature(song,"spectral_bandwidth_min"));
            mfccMax.add(extractSingleFeature(song,"mfcc_max"));
            mfccMin.add(extractSingleFeature(song,"mfcc_min"));
        }
       
    }

 

    String extractSongPath(JSONObject song, String featureName){  
        if (song.hasKey(featureName)) {
           
            String songPath = song.getString(featureName);
            return songPath;

        } else {
        return ""; // Or handle it as needed, e.g., return null or an error message
    }
    }

    //function to extract single data
    int extractSingleFeature(JSONObject song, String featureName) {
        if (song.hasKey(featureName)) {
           
            float durationSeconds = song.getFloat(featureName);
            return int(round(durationSeconds)); 
        } else {
            println("Feature '" + featureName + "' not found in song data.");
            return -1;
        }
    }

    //function to extract an array of data
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
}
