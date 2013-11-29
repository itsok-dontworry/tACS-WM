% pseudocode zur �bersicht, was wir haben, was wir brauchen
%
% GRUNDLEGENDES:                                                           
% - paths hinzuf�gen
% - toolbox hinzuf�gen
% 
% AUSWERTUNG PRO SESSION:
% loop �ber alle sessions (als dateiordner)
%   - session-ordner auf vollst�ndigkeit pr�fen                            initialize.m (done(alex) - ungetestet)
%   - 'loop' �ber beide EEG-Aufnahmen (pre_stim und dur_post_stim)         prepare_datafiles.m (in progress(alex) - ungetestet)
%       - ft_definetrial (1 trial, events)
%       - filtern                                                          filtEEG.m (done?(mark) - ungetestet)
%       - (ICA)                                                            ICA.m (angefangen(alex) - ungetestet)
%       - [trl] definieren                                                 definetrial.m (?(mark) - ?)
%       - ft_redefinetrial (trl-matrix)                                    
%       - trials mit falscher antwort entfernen                            remove_trials.m
%       - trials mit RT > 2*stddev innerhalb der session entfernen         remove_trials.m
%       - trials mit peaktopeak <2uV >100uV entfernen                      artifact_rejection_threshold.m
%       - trials mit artefakten entfernen                                  
%   - EEG-files appenden                                                             
%   - WPLI                                                                 WPLI.m (beta-done(mark) - test eher schlecht)
%   - ANOVA                                                                
