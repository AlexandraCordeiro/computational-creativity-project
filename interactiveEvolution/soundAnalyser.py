import librosa
from matplotlib import pyplot as plt
import numpy as np
import json

numCircles = 361
numLayers = 20

def analyze_audio(file_path, num_slices= numCircles * numLayers):
    # Load the audio file
    y, sr = librosa.load(file_path)

    # Normalize the audio signal
   # y = librosa.util.normalize(y)

    # duration of the audio in seconds
    duration = librosa.get_duration(y=y, sr=sr)
    ms_duration = duration * 1000

     # Calculate the slice duration in samples
    slice_length = len(y) // num_slices

    
    f0_slices = []
    '''
    # fundamental frequency for each slice
    for i in range(num_slices):
        start = i * slice_length
        end = (i + 1) * slice_length
        y_slice = y[start:end]
        #print(y_slice)
       
        f0, voiced_flag, voiced_probs = librosa.pyin(y_slice, fmin=librosa.note_to_hz('C2'), fmax=librosa.note_to_hz('C7'))

        f0_clean = f0[~np.isnan(f0)]
        if f0_clean.size > 0:
            f0_slices.append(np.mean(f0_clean))
        else:
            f0_slices.append(0)  # or another fallback value
        '''
    # Compute the amplitude (unitless)
    amplitude = np.abs(y)

    # amplitude into the desired number of slices
    slice_duration = duration / num_slices
    amplitude_slices = []
    for i in range(num_slices):
        start = int(i * slice_duration * sr)
        end = int((i + 1) * slice_duration * sr)
        amplitude_slices.append(round(float(np.mean(amplitude[start:end])), 3))

    # spectral centroid (frequency in Hz)
    spectral_centroids = librosa.feature.spectral_centroid(y=y, sr=sr)[0]
    times = librosa.times_like(spectral_centroids, sr=sr)
      
    mfccs = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=1)
    spectral_bandwidth = librosa.feature.spectral_bandwidth(y=y, sr=sr)[0]
  

    # Slice and average these features
    def slice_and_average(feature):
        slices = []
        for i in range(num_slices):
            start_time = i * slice_duration
            end_time = (i + 1) * slice_duration
            mask = (times >= start_time) & (times < end_time)
            if np.any(mask):
                slices.append(round(float(np.mean(feature[mask])), 3))
            else:
                slices.append(0.0)
        return slices
    
    # Compute the onset envelope for the entire song
    hop_length = 512  # Adjust hop_length if needed
    onset_env = librosa.onset.onset_strength(y=y, sr=sr, hop_length=hop_length)

    # Estimate the tempo for the entire song
    tempo = librosa.beat.tempo(onset_envelope=onset_env, sr=sr)[0]
    bandwidth_slices = slice_and_average(spectral_bandwidth)
    mfcc_slices = [slice_and_average(mfcc) for mfcc in mfccs]

    # Compute min and max
    spectral_bandwidth_min = np.min(bandwidth_slices)
    spectral_bandwidth_max = np.max(bandwidth_slices)
    mfcc_min = np.min(mfcc_slices, axis=1)
    mfcc_max = np.max(mfcc_slices, axis=1)
    #print(mfcc_min)
 
    # Prepare the data for this audio file
    data = {
        "file_path": file_path,
        "duration": ms_duration,
        "amplitude": amplitude_slices,
        "spectral_bandwidth": bandwidth_slices, #diff between upper and lower frequency correlation with timbre
        "spectral_bandwidth_min": spectral_bandwidth_min,
        "spectral_bandwidth_max": spectral_bandwidth_max,
        "mfcc": mfcc_slices[0],
        "mfcc_min": mfcc_min[0],
        "mfcc_max": mfcc_max[0],
        "fundamental_freq": f0_slices,
        "bpm": tempo
    }
    return data

def save_to_json(all_data, output_file):
    with open(output_file, 'w') as f:
        json.dump(all_data, f, indent=4)

# choose one file_paths
#file_paths = ['./audio/satie/gymnopedie_1.mp3','./audio/satie/gymnopedie_2.mp3','./audio/satie/gymnopedie_3.mp3']
#file_paths = ['./audio/chopin/nocturne_op15_n1.mp3','./audio/chopin/nocturne_op15_n2.mp3','./audio/chopin/nocturne_op15_n3.mp3']
#file_paths = ['./audio/chet/but_not_for_me.mp3','./audio/chet/like_someone_in_love.mp3','./audio/chet/there_will_never_be_another_you.mp3']
file_paths = ['./audio/michaelJackson/Beat_it.mp3','./audio/michaelJackson/billie_jean.mp3','./audio/michaelJackson/thriller.mp3']
#file_paths = ['./audio/xenakis/metastasis.mp3','./audio/xenakis/shaar.mp3','./audio/xenakis/shaar.mp3']

output_file = './outputData/sound_data.json'

# Analyze each audio file and store the results
all_data = {}
for i, file_path in enumerate(file_paths, start=0):
    song_data = analyze_audio(file_path)
    all_data[f"song{i}"] = song_data

# Save the data to a JSON file
save_to_json(all_data, output_file)
print(f"Analysis data saved to {output_file}")
