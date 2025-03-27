export train_cmd=run.pl
export decode_cmd=run.pl # --mem 2G"
# the use of cuda_cmd is deprecated, used only in 'nnet1',
export cuda_cmd=run.pl #--gpu 1"

if [ "$(hostname -d)" == "fit.vutbr.cz" ]; then
  queue_conf=$HOME/queue_conf/default.conf # see example /homes/kazi/iveselyk/queue_conf/default.conf,
  export train_cmd="run.pl --config $queue_conf --mem 2G --matylda 0.2"
  export decode_cmd="run.pl --config $queue_conf --mem 3G --matylda 0.1"
  export cuda_cmd="run.pl --config $queue_conf --gpu 1 --mem 10G --tmp 40G"
fi
