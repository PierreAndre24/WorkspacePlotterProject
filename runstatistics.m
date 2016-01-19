classdef runstatistics
  %runstatistics will store the data on a given run (n sweeps under the same
  %   exp conditions.
  %
  %   encoded properties:
  %     - Ntot = total number of sweeps
  %     - N_injected_1_0 = number of injected electrons,
  %             starting with one electron.
  %     - N_rec_inj = number of electrons caught, knowing
  %             that we sent one
  %     - N_rec_ninj = number of electrons received, knowing
  %             that we didn't send one.
  %     - N_noload = number of traces were the injection dot wasn't loaded.
  %
  %     - N = the complete set of data... just in case
  
  properties
    Ntot;
    N_injected_1_0;
    N_rec_inj;
    N_rec_ninj;
    N_noload;
    N;
  end
  
  methods
  end
  
end