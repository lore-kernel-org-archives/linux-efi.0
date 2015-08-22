From: Arjun Krishnan <arjunkc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: PROBLEM: kernel crashes with efi errors on suspend/hibernate wake and
 at random times
Date: Sat, 22 Aug 2015 09:57:16 +0100
Message-ID: <CAOR2qxtA=Jr4i8qvjLMMZ=fYybA+NGj8dxqN4iHfHMXPoH1Xig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

[1.] Kernel crashes at random times with efi errors in the log

[2.] Full description of the problem/report:

Here are two logs, one is a random crash, and one is right after a
hibernate/wake event:
https://dl.dropboxusercontent.com/u/96020841/Configs/Misc/hibernate_crash-1.log
https://dl.dropboxusercontent.com/u/96020841/Configs/Misc/upower-core-dump.log


Usually see lines like
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff81444375>]
efivar_entry_size+0x45/0x110
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff8126d6c9>]
efivarfs_file_read+0x49/0x100
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff811e04f7>]
__vfs_read+0x37/0x100
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff8128381e>] ?
security_file_permission+0x8e/0xa0
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff811e0e67>] vfs_read+0x87/0x140
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff811e1c79>] SyS_read+0x59/0xd0
Aug 20 11:42:32 arjun-thinkpad kernel:  [<ffffffff8158beae>]
system_call_fastpath+0x12/0x71

[3.] Keywords: efi, nmi, power

[4.] Kernel version (from /proc/version):
Linux version 4.1.4-1-ARCH (builduser@foutrelis) (gcc version 5.2.0
(GCC) ) #1 SMP PREEMPT Mon Aug 3 21:30:37 UTC 2015

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
I think this is what I ought to include...

Aug 22 08:50:55 arjun-thinkpad kernel: Oops: 0011 [#1] PREEMPT SMP

Aug 22 08:50:55 arjun-thinkpad kernel: Modules linked in: ctr ccm
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common
videodev media joydev mousedev btusb btbcm btintel bnep bluetooth
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic msr
iTCO_wdt iTCO_vendor_support arc4 intel_rapl fuse iosf_mbi
x86_pkg_temp_thermal intel_powerclamp coretemp kvm iwlmvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mac80211 aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd evdev mac_hid
psmouse serio_raw iwlwifi pcspkr cfg80211 i915 rtsx_pci_ms memstick
thermal wmi drm_kms_helper snd_hda_intel snd_hda_controller
snd_hda_codec thinkpad_acpi snd_hda_core snd_hwdep nvram snd_pcm drm
led_class tpm_tis intel_gtt rfkill battery ac tpm video i2c_i801
snd_timer i2c_algo_bit e1000e snd i2c_core shpchp
Aug 22 08:50:55 arjun-thinkpad kernel:  soundcore mei_me ptp pps_core
mei lpc_ich processor button sch_fq_codel nfs lockd grace sunrpc
fscache ip_tables x_tables ext4 crc16 mbcache jbd2 dm_mod
hid_multitouch usbhid hid sd_mod rtsx_pci_sdmmc mmc_core atkbd libps2
crc32c_intel ehci_pci ehci_hcd ahci libahci libata xhci_pci scsi_mod
xhci_hcd rtsx_pci usbcore usb_common i8042 serio
Aug 22 08:50:55 arjun-thinkpad kernel: CPU: 1 PID: 5923 Comm:
efibootmgr Not tainted 4.1.4-1-ARCH #1
Aug 22 08:50:55 arjun-thinkpad kernel: Hardware name: LENOVO
20BW0007US/20BW0007US, BIOS JBET45WW (1.10 ) 02/03/2015
Aug 22 08:50:55 arjun-thinkpad kernel: task: ffff88022a989e90 ti:
ffff8801ba0c0000 task.ti: ffff8801ba0c0000
Aug 22 08:50:55 arjun-thinkpad kernel: RIP: 0010:[<0000000000000000>]
[<          (null)>]           (null)
Aug 22 08:50:55 arjun-thinkpad kernel: RSP: 0018:ffff8801ba0c3ca8
EFLAGS: 00010002
Aug 22 08:50:55 arjun-thinkpad kernel: RAX: ffff8801ba0c3d68 RBX:
ffff8802324c4000 RCX: ffff8802324c4000
Aug 22 08:50:55 arjun-thinkpad kernel: RDX: ffff8802324c4400 RSI:
ffff8802324c4000 RDI: 0000000000000000
Aug 22 08:50:55 arjun-thinkpad kernel: RBP: ffff8801ba0c3d98 R08:
0000000000000000 R09: ffff8801ba0c3de8
Aug 22 08:50:55 arjun-thinkpad kernel: R10: 0000000000000378 R11:
0000000000000246 R12: 0000000000000092
Aug 22 08:50:55 arjun-thinkpad kernel: R13: ffff8802324c4400 R14:
0000000000000000 R15: 0000000000099000
Aug 22 08:50:55 arjun-thinkpad kernel: FS:  00007f78285f8700(0000)
GS:ffff88023dc40000(0000) knlGS:0000000000000000
Aug 22 08:50:55 arjun-thinkpad kernel: CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Aug 22 08:50:55 arjun-thinkpad kernel: CR2: 0000000000000000 CR3:
0000000000099000 CR4: 00000000003407e0
Aug 22 08:50:55 arjun-thinkpad kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Aug 22 08:50:55 arjun-thinkpad kernel: DR3: 0000000000000000 DR6:
00000000fffe0ff0 DR7: 0000000000000400
Aug 22 08:50:55 arjun-thinkpad kernel: Stack:
Aug 22 08:50:55 arjun-thinkpad kernel:  ffffffff81072e2e
0000002db99473be ffff88020264c036 ffff8800b2c9e100
Aug 22 08:50:55 arjun-thinkpad kernel:  0000002400009e90
0000000000000000 ffff8801ba0c3d68 ffff8801ba0c3d50
Aug 22 08:50:55 arjun-thinkpad kernel:  0000000080050033
0000000000000000 0000000000000000 00ffffffffffffff
Aug 22 08:50:55 arjun-thinkpad kernel: Call Trace:
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff81072e2e>] ?
efi_call+0x7e/0x100
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff81446eaf>] ?
virt_efi_get_variable+0x6f/0xb0
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff81444375>]
efivar_entry_size+0x45/0x110
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff8126d6c9>]
efivarfs_file_read+0x49/0x100
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff811e04f7>]
__vfs_read+0x37/0x100
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff8128381e>] ?
security_file_permission+0x8e/0xa0
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff811e0e67>] vfs_read+0x87/0x140
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff811e1c79>] SyS_read+0x59/0xd0
Aug 22 08:50:55 arjun-thinkpad kernel:  [<ffffffff8158beae>]
system_call_fastpath+0x12/0x71
Aug 22 08:50:55 arjun-thinkpad kernel: Code:  Bad RIP value.
Aug 22 08:50:55 arjun-thinkpad kernel: RIP  [<          (null)>]
    (null)
Aug 22 08:50:55 arjun-thinkpad kernel:  RSP <ffff8801ba0c3ca8>
Aug 22 08:50:55 arjun-thinkpad kernel: CR2: 0000000000000000
Aug 22 08:50:55 arjun-thinkpad kernel: ---[ end trace a1833a247d0762a1 ]---
Aug 22 08:50:55 arjun-thinkpad kernel: note: efibootmgr[5923] exited
with preempt_count 3
Aug 22 08:50:55 arjun-thinkpad sudo[5921]: pam_unix(sudo:session):
session closed for user root
-- Reboot --

[7.] Environment
Arch linux, xfce, i3 or cinnamon.

[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux arjun-thinkpad 4.1.4-1-ARCH #1 SMP PREEMPT Mon Aug 3 21:30:37
UTC 2015 x86_64 GNU/Linux

Gnu C                  5.2.0
Gnu make               4.1
binutils               2.25.1
util-linux             2.26.2
mount                  debug
module-init-tools      21
e2fsprogs              1.42.12
jfsutils               1.1.15
reiserfsprogs          3.6.24
xfsprogs               3.2.2
pcmciautils            018
PPP                    2.4.7
Linux C Library        Dynamic linker (ldd)   2.22
Linux C++ Library      6.0.21
Procps                 3.3.10
Net-tools              2.10-alpha
Kbd                    2.0.2
Sh-utils               8.24
wireless-tools         30
Modules Loaded         ctr ccm uvcvideo videobuf2_vmalloc
videobuf2_memops videobuf2_core v4l2_common videodev media joydev
mousedev bnep btusb btbcm btintel bluetooth snd_hda_codec_hdmi
snd_hda_codec_realtek msr snd_hda_codec_generic iTCO_wdt
iTCO_vendor_support arc4 intel_rapl iosf_mbi x86_pkg_temp_thermal
intel_powerclamp coretemp fuse iwlmvm kvm mac80211 crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel i915 aesni_intel aes_x86_64 lrw
psmouse gf128mul glue_helper ablk_helper cryptd iwlwifi evdev
snd_hda_intel mac_hid snd_hda_controller drm_kms_helper serio_raw
pcspkr e1000e drm i2c_i801 snd_hda_codec rtsx_pci_ms cfg80211
snd_hda_core snd_hwdep memstick intel_gtt thinkpad_acpi snd_pcm
lpc_ich ptp snd_timer nvram pps_core mei_me i2c_algo_bit led_class snd
i2c_core tpm_tis mei shpchp soundcore rfkill tpm wmi thermal ac
battery video processor button sch_fq_codel nfs lockd grace sunrpc
fscache ip_tables x_tables ext4 crc16 mbcache jbd2 dm_mod
hid_multitouch usbhid hid sd_mod rtsx_pci_sdmmc mmc_core atkbd libps2
ahci libahci crc32c_intel libata xhci_pci ehci_pci ehci_hcd xhci_hcd
scsi_mod rtsx_pci usbcore usb_common i8042 serio

[7.2.] Processor information (from /proc/cpuinfo):
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 61
model name : Intel(R) Core(TM) i5-5300U CPU @ 2.30GHz
stepping : 4
microcode : 0x1a
cpu MHz : 2300.359
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 2
apicid : 0
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 20
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle
avx2 smep bmi2 erms invpcid rtm rdseed adx smap xsaveopt
bugs :
bogomips : 4591.01
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 61
model name : Intel(R) Core(TM) i5-5300U CPU @ 2.30GHz
stepping : 4
microcode : 0x1a
cpu MHz : 2300.089
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 2
apicid : 1
initial apicid : 1
fpu : yes
fpu_exception : yes
cpuid level : 20
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle
avx2 smep bmi2 erms invpcid rtm rdseed adx smap xsaveopt
bugs :
bogomips : 4591.01
clflush size : 64
cache_alignment : 64
model : 61
model name : Intel(R) Core(TM) i5-5300U CPU @ 2.30GHz
stepping : 4
microcode : 0x1a
cpu MHz : 2300.000
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 2
apicid : 2
initial apicid : 2
fpu : yes
fpu_exception : yes
cpuid level : 20
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle
avx2 smep bmi2 erms invpcid rtm rdseed adx smap xsaveopt
bugs :
bogomips : 4591.01
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 61
model name : Intel(R) Core(TM) i5-5300U CPU @ 2.30GHz
stepping : 4
microcode : 0x1a
cpu MHz : 2300.089
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 1
cpu cores : 2
apicid : 3
initial apicid : 3
fpu : yes
fpu_exception : yes
cpuid level : 20
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2
x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand
lahf_lm abm 3dnowprefetch ida arat epb pln pts dtherm intel_pt
tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle
avx2 smep bmi2 erms invpcid rtm rdseed adx smap xsaveopt
bugs :
bogomips : 4591.01
clflush size : 64
cache_alignment : 64
address sizes : 39 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
ctr 16384 2 - Live 0xffffffffa06ad000
ccm 20480 2 - Live 0xffffffffa06a7000
uvcvideo 90112 0 - Live 0xffffffffa09f3000
videobuf2_vmalloc 16384 1 uvcvideo, Live 0xffffffffa0709000
videobuf2_memops 16384 1 videobuf2_vmalloc, Live 0xffffffffa0704000
videobuf2_core 40960 1 uvcvideo, Live 0xffffffffa06bc000
v4l2_common 16384 1 videobuf2_core, Live 0xffffffffa0696000
videodev 139264 3 uvcvideo,videobuf2_core,v4l2_common, Live 0xffffffffa09d0000
media 20480 2 uvcvideo,videodev, Live 0xffffffffa06a1000
joydev 20480 0 - Live 0xffffffffa0659000
mousedev 20480 0 - Live 0xffffffffa0401000
bnep 24576 2 - Live 0xffffffffa06cb000
btusb 45056 0 - Live 0xffffffffa068a000
btbcm 16384 1 btusb, Live 0xffffffffa056a000
btintel 16384 1 btusb, Live 0xffffffffa0511000
bluetooth 458752 8 bnep,btusb,btbcm,btintel, Live 0xffffffffa095f000
snd_hda_codec_hdmi 53248 1 - Live 0xffffffffa0438000
snd_hda_codec_realtek 77824 1 - Live 0xffffffffa06d2000
msr 16384 0 - Live 0xffffffffa0518000
snd_hda_codec_generic 69632 1 snd_hda_codec_realtek, Live 0xffffffffa0526000
iTCO_wdt 16384 0 - Live 0xffffffffa048f000
iTCO_vendor_support 16384 1 iTCO_wdt, Live 0xffffffffa0565000
arc4 16384 2 - Live 0xffffffffa0560000
intel_rapl 20480 0 - Live 0xffffffffa0539000
iosf_mbi 16384 1 intel_rapl, Live 0xffffffffa069c000
x86_pkg_temp_thermal 16384 0 - Live 0xffffffffa03ed000
intel_powerclamp 16384 0 - Live 0xffffffffa03ba000
coretemp 16384 0 - Live 0xffffffffa0352000
fuse 90112 5 - Live 0xffffffffa06e8000
iwlmvm 237568 0 - Live 0xffffffffa0acb000
kvm 442368 0 - Live 0xffffffffa08f2000
mac80211 667648 1 iwlmvm, Live 0xffffffffa084e000
crct10dif_pclmul 16384 0 - Live 0xffffffffa0485000
crc32_pclmul 16384 0 - Live 0xffffffffa048a000
ghash_clmulni_intel 16384 0 - Live 0xffffffffa032f000
i915 1044480 4 - Live 0xffffffffa071d000
aesni_intel 172032 4 - Live 0xffffffffa065f000
aes_x86_64 20480 1 aesni_intel, Live 0xffffffffa0461000
lrw 16384 1 aesni_intel, Live 0xffffffffa03b0000
psmouse 122880 0 - Live 0xffffffffa05f1000
gf128mul 16384 1 lrw, Live 0xffffffffa03b5000
glue_helper 16384 1 aesni_intel, Live 0xffffffffa045c000
ablk_helper 16384 1 aesni_intel, Live 0xffffffffa03ab000
cryptd 20480 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0xffffffffa0520000
iwlwifi 176128 1 iwlmvm, Live 0xffffffffa062d000
evdev 24576 15 - Live 0xffffffffa053f000
snd_hda_intel 28672 5 - Live 0xffffffffa03d3000
mac_hid 16384 0 - Live 0xffffffffa0381000
snd_hda_controller 28672 1 snd_hda_intel, Live 0xffffffffa034a000
drm_kms_helper 106496 1 i915, Live 0xffffffffa0612000
serio_raw 16384 0 - Live 0xffffffffa02d1000
pcspkr 16384 0 - Live 0xffffffffa018c000
e1000e 221184 0 - Live 0xffffffffa0573000
drm 286720 5 i915,drm_kms_helper, Live 0xffffffffa05aa000
i2c_i801 20480 0 - Live 0xffffffffa047a000
snd_hda_codec 98304 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller,
Live 0xffffffffa0547000
rtsx_pci_ms 20480 0 - Live 0xffffffffa0469000
cfg80211 483328 3 iwlmvm,mac80211,iwlwifi, Live 0xffffffffa049a000
snd_hda_core 28672 5
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_controller,s00
lpc_ich 24576 0 - Live 0xffffffffa042b000
ptp 20480 1 e1000e, Live 0xffffffffa040a000
snd_timer 28672 1 snd_pcm, Live 0xffffffffa0357000
nvram 16384 1 thinkpad_acpi, Live 0xffffffffa03fc000
pps_core 20480 1 ptp, Live 0xffffffffa03f2000
mei_me 24576 0 - Live 0xffffffffa03e6000
i2c_algo_bit 16384 1 i915, Live 0xffffffffa0345000
led_class 16384 2 iwlmvm,thinkpad_acpi, Live 0xffffffffa03dd000
snd 69632 19 snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,thinkpad_acpi,snd_pcm,snd_timer,
Live 0xffffffffa03c1000
i2c_core 49152 7
v4l2_common,videodev,i915,drm_kms_helper,drm,i2c_i801,i2c_algo_bit,
Live 0xffffffffa02c4000
tpm_tis 20480 0 - Live 0xffffffffa0360000
mei 77824 1 mei_me, Live 0xffffffffa038d000
shpchp 36864 0 - Live 0xffffffffa03a1000
soundcore 16384 1 snd, Live 0xffffffffa0388000
rfkill 24576 5 bluetooth,cfg80211,thinkpad_acpi, Live 0xffffffffa036f000
tpm 32768 1 tpm_tis, Live 0xffffffffa0366000
wmi 20480 0 - Live 0xffffffffa033b000
thermal 20480 0 - Live 0xffffffffa0335000
ac 16384 0 - Live 0xffffffffa02dc000
battery 20480 0 - Live 0xffffffffa02d6000
video 24576 1 i915, Live 0xffffffffa037a000
processor 28672 0 - Live 0xffffffffa0276000
button 16384 1 i915, Live 0xffffffffa013e000
sch_fq_codel 20480 6 - Live 0xffffffffa0109000
nfs 212992 0 - Live 0xffffffffa02fa000
lockd 90112 1 nfs, Live 0xffffffffa02e3000
grace 16384 1 lockd, Live 0xffffffffa00a7000
sunrpc 278528 2 nfs,lockd, Live 0xffffffffa027f000
fscache 57344 1 nfs, Live 0xffffffffa0198000
ip_tables 28672 0 - Live 0xffffffffa00b5000
x_tables 28672 1 ip_tables, Live 0xffffffffa0136000
ext4 516096 7 - Live 0xffffffffa01f7000
crc16 16384 2 bluetooth,ext4, Live 0xffffffffa000f000
mbcache 20480 1 ext4, Live 0xffffffffa0093000
jbd2 90112 1 ext4, Live 0xffffffffa01e0000
dm_mod 102400 30 - Live 0xffffffffa01c6000
hid_multitouch 20480 0 - Live 0xffffffffa0024000
usbhid 49152 0 - Live 0xffffffffa009a000
hid 110592 2 hid_multitouch,usbhid, Live 0xffffffffa0071000
sd_mod 36864 3 - Live 0xffffffffa001a000
rtsx_pci_sdmmc 24576 0 - Live 0xffffffffa0102000
mmc_core 114688 1 rtsx_pci_sdmmc, Live 0xffffffffa01a9000
atkbd 24576 0 - Live 0xffffffffa00fb000
libps2 16384 2 psmouse,atkbd, Live 0xffffffffa0193000
ahci 36864 2 - Live 0xffffffffa0182000
libahci 28672 1 ahci, Live 0xffffffffa017a000
crc32c_intel 24576 0 - Live 0xffffffffa00ae000
libata 204800 2 ahci,libahci, Live 0xffffffffa0147000
xhci_pci 16384 0 - Live 0xffffffffa008e000
ehci_pci 16384 0 - Live 0xffffffffa000a000
ehci_hcd 73728 1 ehci_pci, Live 0xffffffffa00c0000
xhci_hcd 155648 1 xhci_pci, Live 0xffffffffa010f000
scsi_mod 151552 2 sd_mod,libata, Live 0xffffffffa00d5000
rtsx_pci 45056 2 rtsx_pci_ms,rtsx_pci_sdmmc, Live 0xffffffffa002a000
usbcore 200704 7
uvcvideo,btusb,usbhid,xhci_pci,ehci_pci,ehci_hcd,xhci_hcd, Live
0xffffffffa003f000
usb_common 16384 1 usbcore, Live 0xffffffffa003a000
i8042 20480 1 libps2, Live 0xffffffffa0014000
serio 20480 7 psmouse,serio_raw,atkbd,i8042, Live 0xffffffffa0000000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0061-0061 : PNP0800:00
  0062-0062 : PNP0C09:00
    0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : PNP0C09:00
    0066-0066 : EC cmd
  0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
    00f0-00f0 : PNP0C04:00
  0800-087f : pnp 00:01
  0880-08ff : pnp 00:01
  0900-097f : pnp 00:01
  0980-09ff : pnp 00:01
  0a00-0a7f : pnp 00:01
  0a80-0aff : pnp 00:01
  0b00-0b7f : pnp 00:01
  0b80-0bff : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  15e0-15ef : pnp 00:01
  1600-167f : pnp 00:01
    1640-165f : pnp 00:01
  1800-1803 : ACPI PM1a_EVT_BLK
  1804-1805 : ACPI PM1a_CNT_BLK
  1808-180b : ACPI PM_TMR
  1810-1815 : ACPI CPU throttle
  1830-1833 : iTCO_wdt
    1830-1833 : iTCO_wdt
  1850-1850 : ACPI PM2_CNT_BLK
  1860-187f : iTCO_wdt
    1860-187f : iTCO_wdt
  1880-189f : ACPI GPE0_BLK
  3000-303f : 0000:00:02.0
  3060-307f : 0000:00:1f.2
    3060-307f : ahci
  3080-309f : 0000:00:19.0
  30a0-30a7 : 0000:00:1f.2
    30a0-30a7 : ahci
  30a8-30af : 0000:00:1f.2
    30a8-30af : ahci
  30b8-30bb : 0000:00:1f.2
    30b8-30bb : ahci
  30bc-30bf : 0000:00:1f.2
    30bc-30bf : ahci
  efa0-efbf : 0000:00:1f.3
    efa0-efbf : i801_smbus

00000000-00000fff : reserved
00001000-00057fff : System RAM
00058000-00058fff : reserved
00059000-0009bfff : System RAM
0009c000-0009cfff : reserved
0009d000-0009dfff : System RAM
0009e000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c3fff : PCI Bus 0000:00
000c4000-000c7fff : PCI Bus 0000:00
000c8000-000cbfff : PCI Bus 0000:00
000cc000-000cffff : PCI Bus 0000:00
000d0000-000d3fff : PCI Bus 0000:00
000ec000-000effff : pnp 00:00
000f0000-000fffff : System ROM
00100000-bbd05fff : System RAM
  01000000-01590e9e : Kernel code
  01590e9f-018df5bf : Kernel data
  01a0e000-01b2dfff : Kernel bss
bbd06000-bbf05fff : reserved
bbf06000-bcbfefff : reserved
bcbff000-bcd7efff : ACPI Non-volatile Storage
bcd7f000-bcdfefff : ACPI Tables
bcdff000-bcdfffff : System RAM
bce00000-bdffffff : RAM buffer
be000000-bfffffff : reserved
  be000000-bfffffff : Graphics Stolen Memory
c0000000-febfffff : PCI Bus 0000:00
  c0000000-c000ffff : pnp 00:06
  c0010000-c001ffff : pnp 00:06
  d0000000-dfffffff : 0000:00:02.0
  e0000000-e0ffffff : 0000:00:02.0
  e1000000-e10fffff : PCI Bus 0000:03
    e1000000-e1001fff : 0000:03:00.0
      e1000000-e1001fff : iwlwifi
  e1100000-e11fffff : PCI Bus 0000:02
    e1100000-e1100fff : 0000:02:00.0
      e1100000-e1100fff : rtsx_pci
  e1200000-e121ffff : 0000:00:19.0
    e1200000-e121ffff : e1000e
  e1220000-e122ffff : 0000:00:14.0
    e1220000-e122ffff : xhci-hcd
  e1230000-e1233fff : 0000:00:03.0
    e1230000-e1233fff : ICH HD audio
  e1234000-e1237fff : 0000:00:1b.0
    e1234000-e1237fff : ICH HD audio
  e1238000-e12380ff : 0000:00:1f.3
  e1239000-e123901f : 0000:00:16.0
    e1239000-e123901f : mei_me
  e123b000-e123bfff : 0000:00:1f.6
  e123c000-e123c7ff : 0000:00:1f.2
    e123c000-e123c7ff : ahci
  e123d000-e123d3ff : 0000:00:1d.0
    e123d000-e123d3ff : ehci_hcd
  e123e000-e123efff : 0000:00:19.0
    e123e000-e123efff : e1000e
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f80f8000-f80f8fff : reserved
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : PNP0103:00
fed10000-fed13fff : pnp 00:01
fed18000-fed18fff : pnp 00:01
fed19000-fed19fff : pnp 00:01
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:01
    fed1f410-fed1f414 : iTCO_wdt
      fed1f410-fed1f414 : iTCO_wdt
fed40000-fed4bfff : PCI Bus 0000:00
  fed45000-fed4bfff : pnp 00:01
fed4c000-ffffffff : pnp 00:00
  fee00000-fee00fff : Local APIC
100000000-23dffffff : System RAM
23e000000-23fffffff : RAM buffer

[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation Broadwell-U Host Bridge -OPI (rev 09)
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:02.0 VGA compatible controller: Intel Corporation Broadwell-U
Integrated Graphics (rev 09) (prog-if 00 [VGA controller])
Subsystem: Lenovo Device 5036
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 47
Region 0: Memory at e0000000 (64-bit, non-prefetchable) [size=16M]
Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
Region 4: I/O ports at 3000 [size=64]
Expansion ROM at <unassigned> [disabled]
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 4182
Capabilities: [d0] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a4] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: i915
Kernel modules: i915

00:03.0 Audio device: Intel Corporation Broadwell-U Audio Controller (rev 09)
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 48
Region 0: Memory at e1230000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D3 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 4192
Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

00:14.0 USB controller: Intel Corporation Wildcat Point-LP USB xHCI
Controller (rev 03) (prog-if 30 [XHCI])
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 41
Region 0: Memory at e1220000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [70] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41b1
Kernel driver in use: xhci_hcd
Kernel modules: xhci_pci

00:16.0 Communication controller: Intel Corporation Wildcat Point-LP
MEI Controller #1 (rev 03)
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 43
Region 0: Memory at e1239000 (64-bit, non-prefetchable) [size=32]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41e1
Kernel driver in use: mei_me
Kernel modules: mei_me

00:19.0 Ethernet controller: Intel Corporation Ethernet Connection (3)
I218-LM (rev 03)
Subsystem: Lenovo Device 2226
Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin A routed to IRQ 44
Region 0: Memory at e1200000 (32-bit, non-prefetchable) [disabled] [size=128K]
Region 1: Memory at e123e000 (32-bit, non-prefetchable) [disabled] [size=4K]
Region 2: I/O ports at 3080 [disabled] [size=32]
Capabilities: [c8] Power Management version 2
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D3 NoSoftRst- PME-Enable+ DSel=0 DScale=1 PME-
Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 41b2
Capabilities: [e0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: e1000e
Kernel modules: e1000e

00:1b.0 Audio device: Intel Corporation Wildcat Point-LP High
Definition Audio Controller (rev 03)
Subsystem: Lenovo Device 5036
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 32, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 46
Region 0: Memory at e1234000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D3 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 4172
Kernel driver in use: snd_hda_intel
Kernel modules: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express
Root Port #6 (rev e3) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin B routed to IRQ 17
Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: e1100000-e11fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #6, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <16us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
LnkCtl: ASPM L0s L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #5, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Lenovo Device 5034
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v0] #00
Capabilities: [200 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1c.1 PCI bridge: Intel Corporation Wildcat Point-LP PCI Express
Root Port #3 (rev e3) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin C routed to IRQ 18
Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: e1000000-e10fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #3, Speed 5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s
<512ns, L1 <16us
ClockPM- Surprise- LLActRep+ BwNot+ ASPMOptComp-
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #2, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet- LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range ABC, TimeoutDis+, LTR+, OBFF Not
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000
Capabilities: [90] Subsystem: Lenovo Device 5034
Capabilities: [a0] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [100 v0] #00
Capabilities: [200 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=40us PortTPowerOnTime=10us
Kernel driver in use: pcieport
Kernel modules: shpchp

00:1d.0 USB controller: Intel Corporation Wildcat Point-LP USB EHCI
Controller (rev 03) (prog-if 20 [EHCI])
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 0: Memory at e123d000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci-pci
Kernel modules: ehci_pci

00:1f.0 ISA bridge: Intel Corporation Wildcat Point-LP LPC Controller (rev 03)
Subsystem: Lenovo Device 5034
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>
Kernel driver in use: lpc_ich
Kernel modules: lpc_ich

00:1f.2 SATA controller: Intel Corporation Wildcat Point-LP SATA
Controller [AHCI Mode] (rev 03) (prog-if 01 [AHCI 1.0])
Subsystem: Lenovo Device 5034
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 42
Region 0: I/O ports at 30a8 [size=8]
Region 1: I/O ports at 30bc [size=4]
Region 2: I/O ports at 30a0 [size=8]
Region 3: I/O ports at 30b8 [size=4]
Region 4: I/O ports at 3060 [size=32]
Region 5: Memory at e123c000 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c  Data: 41d1
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
Kernel driver in use: ahci
Kernel modules: ahci

00:1f.3 SMBus: Intel Corporation Wildcat Point-LP SMBus Controller (rev 03)
Subsystem: Lenovo Device 5034
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin C routed to IRQ 18
Region 0: Memory at e1238000 (64-bit, non-prefetchable) [size=256]
Region 4: I/O ports at efa0 [size=32]
Kernel driver in use: i801_smbus
Kernel modules: i2c_i801

00:1f.6 Signal processing controller: Intel Corporation Wildcat
Point-LP Thermal Management Controller (rev 03)
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin C routed to IRQ 255
Region 0: Memory at e123b000 (64-bit, non-prefetchable) [size=4K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000  Data: 0000

02:00.0 Unassigned class [ff00]: Realtek Semiconductor Co., Ltd.
RTS5227 PCI Express Card Reader (rev 01)
Subsystem: Lenovo Device 5034
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 40
Region 0: Memory at e1100000 (32-bit, non-prefetchable) [size=4K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 4191
Capabilities: [70] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency
L0s unlimited, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR+, OBFF
Via message/WAKE#
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v2] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Device Serial Number 00-00-00-01-00-4c-e0-00
Capabilities: [150 v1] Latency Tolerance Reporting
Max snoop latency: 71680ns
Max no snoop latency: 71680ns
Capabilities: [158 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=60us PortTPowerOnTime=60us
Kernel driver in use: rtsx_pci
Kernel modules: rtsx_pci

03:00.0 Network controller: Intel Corporation Wireless 7265 (rev 59)
Subsystem: Intel Corporation Dual Band Wireless-AC 7265
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 45
Region 0: Memory at e1000000 (64-bit, non-prefetchable) [size=8K]
Capabilities: [c8] Power Management version 3
Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c  Data: 4152
Capabilities: [40] Express (v2) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 unlimited
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr+ NoSnoop+ FLReset-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L1, Exit Latency L0s
<4us, L1 <32us
ClockPM+ Surprise- LLActRep- BwNot- ASPMOptComp+
LnkCtl: ASPM L1 Enabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM+ AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range B, TimeoutDis+, LTR+, OBFF Via WAKE#
DevCtl2: Completion Timeout: 16ms to 55ms, TimeoutDis-, LTR+, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
Capabilities: [140 v1] Device Serial Number 60-57-18-ff-ff-90-68-6b
Capabilities: [14c v1] Latency Tolerance Reporting
Max snoop latency: 71680ns
Max no snoop latency: 71680ns
Capabilities: [154 v1] L1 PM Substates
L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
 PortCommonModeRestoreTime=30us PortTPowerOnTime=60us
Kernel driver in use: iwlwifi
Kernel modules: iwlwifi

[7.6.] SCSI information (from /proc/scsi/scsi)

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
