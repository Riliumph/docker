# config

## system

### worker

```conf
<system>
  workers 4
</system>

<worker 0>
@include metrics.conf
</worker>
```

```console
/$ ps ux | awk 'NR==1 || /[f]luentd/'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
fluent       1  0.0  0.0  16604  8996 ?        Ss   01:23   0:00 tini -- /bin/entrypoint.sh fluentd
fluent       7  0.0  0.5 161340 56540 ?        Sl   01:23   0:01 /usr/local/bin/ruby /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins
fluent      16  0.0  0.4 131812 41436 ?        Sl   01:23   0:00 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
fluent      96  0.0  0.5 161340 55520 ?        Sl   01:23   0:01 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
fluent      97  0.1  0.5 182344 55444 ?        Sl   01:23   0:01 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
fluent      98  0.1  0.5 188488 55532 ?        Sl   01:23   0:01 /usr/local/bin/ruby -Eascii-8bit:ascii-8bit /usr/local/bundle/bin/fluentd --config /fluentd/etc/fluent.conf --plugin /fluentd/plugins --under-supervisor
```

PIDが16,96,97,98で動いていることが分かる。  
PID1はfluentdイメージのエントリポイントで、PID7が親プロセスである。
