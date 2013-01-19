From: Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: 2TB USB hard drive for backing up
Date: Sat, 19 Jan 2013 21:40:59 +0000
Message-ID: <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
References: <jmunm9$90r$2@speranza.aioe.org>
	<201204301814.21525.Martin@lichtvoll.de>
	<CAGZeNoc82T0jS=Sg3d2umqi6PjAWjOKjqK2RbuK+QfAzN3Pmww@mail.gmail.com>
	<201205010044.24643.Martin@lichtvoll.de>
	<CAGZeNoeSEtTMK22+JcsG7xRRrbsQwgJV5iLgWenrX=rvLr-ZXQ@mail.gmail.com>
	<CAGZeNof6NWiXhCDPpZiLu8QhQ_6Cmp-nhSOf=h=-jAjccWaa7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f46d042e005f6e085a04d3ab15a9
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGZeNof6NWiXhCDPpZiLu8QhQ_6Cmp-nhSOf=h=-jAjccWaa7g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

--f46d042e005f6e085a04d3ab15a9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi.

I've had this problem for so long that today after compiling kernel
3.7.3 and not getting any improvements I decided to let you know that
some of us still only able to use our GPT 3TB hard disks only on
Windows.

On linux only hdparm and gdisk see 3TB but also see some kind of
corruption on the alternate GPT which is not true because on windows
works flawlessly.

I hope you won't take too long to make it work because this is the
only reason I still loging in on windows, before buying this disk I
didn't log in on windows at all.

I don't need the EFI drivers to work because the BIOS is not ready for
that, I only would like to read and write on the disk which is already
half full and cannot do any new experiments trying to fix it with
gdisk.

I only need the kernel GPT drivers to work out.


Cheers.




---------- Forwarded message ----------
From: Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 2012/6/22
Subject: Fwd: 2TB USB hard drive for backing up
To: 678568-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org


---------- Forwarded message ----------
From: Ellwood Blues <elwood.blue-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: 2012/5/3
Subject: Re: 2TB USB hard drive for backing up
To: debian-user-0aAXYlwwYIJuHlm7Suoebg@public.gmane.org


2012/4/30 Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>:
> Am Montag, 30. April 2012 schrieb Ellwood Blues:
>> 2012/4/30 Martin Steigerwald <Martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>:
>> > Am Montag, 30. April 2012 schrieb Chris Bannister:
>> >> On Sun, Apr 29, 2012 at 08:27:03PM +0200, Martin Steigerwald wrote:
>> >> > Hmmm, I=B4d avoid those with 4 KB hardware sectors that lie to the
>> >> > OS they have 512 byte sectors. Although I think even those should
>> >> > work. But with 512 byte sectors you have a 2 TB limit when you
>> >> > use MBR partitioning.
>> >> >
>> >> > 3 TB disks with 4 KB sectors both hardware (physical) and software
>> >> > (logical) should just work, provided the Linux is new enough.
>> >> >
>> >> > On Squeeze use -cu as additional options (see manpage).
>> >>
>> >> Sorry for jumping in here, but I can't figure out (from your post)
>> >> which command requires the additional options: -cu. Which manpage?
>> >
>> > fdisk. Sorry if I didn=B4t mention it anywhere in my post.
>>
>> Thanks, I've tried everything but not success. The problem is that the
>> disk is already half full and aligned with WD tools. I am just waiting
>> for linux to be able to read it and write it as efficiently as Windows
>> does it, at the moment I am not able to read it, which is very
>> frustrating.
>
> I would like to see some information from the disk, like
>
> - relevant stuff from hdparm -I /dev/yourdisk (feel free to skip serial
> number if you do not want to post it here)
> - fdisk -cul /dev/yourdisk
> - tail -fn0 /var/log/syslog / dmesg when the kernel detects the disk
>
> for starters.
>
> You need to use GPT if the disk reports 512 byte sectors to the OS. Thats
> no problem, when its just a data disk. Try gdisk on the disk.

Sorry for the delay. Her you have what you've asked attached as files
and as text on the message:


/dev/sdf:

ATA device, with non-removable media
       Model Number:       WDC WD30EZRX-00MMMB0
       Serial Number:      WD-WCAWZxxxxxxx
       Firmware Revision:  80.00A80
       Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
       Supported: 8 7 6 5
       Likely used: 8
Configuration:
       Logical         max     current
       cylinders       16383   16383
       heads           16      16
       sectors/track   63      63
       --
       CHS current addressable sectors:   16514064
       LBA    user addressable sectors:  268435455
       LBA48  user addressable sectors: 5860533168
       Logical  Sector size:                   512 bytes
       Physical Sector size:                  4096 bytes
       Logical Sector-0 offset:                  0 bytes
       device size with M =3D 1024*1024:     2861588 MBytes
       device size with M =3D 1000*1000:     3000592 MBytes (3000 GB)
       cache/buffer size  =3D unknown
Capabilities:
       LBA, IORDY(can be disabled)
       Queue depth: 32
       Standby timer values: spec'd by Standard, with device specific minim=
um
       R/W multiple sector transfer: Max =3D 16  Current =3D 0
       DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
            Cycle time: min=3D120ns recommended=3D120ns
       PIO: pio0 pio1 pio2 pio3 pio4
            Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
       Enabled Supported:
          *    SMART feature set
               Security Mode feature set
          *    Power Management feature set
          *    Write cache
          *    Look-ahead
          *    Host Protected Area feature set
          *    WRITE_BUFFER command
          *    READ_BUFFER command
          *    NOP cmd
          *    DOWNLOAD_MICROCODE
               Power-Up In Standby feature set
          *    SET_FEATURES required to spinup after power up
               SET_MAX security extension
          *    48-bit Address feature set
          *    Device Configuration Overlay feature set
          *    Mandatory FLUSH_CACHE
          *    FLUSH_CACHE_EXT
          *    SMART error logging
          *    SMART self-test
          *    General Purpose Logging feature set
          *    64-bit World wide name
          *    {READ,WRITE}_DMA_EXT_GPL commands
          *    Segmented DOWNLOAD_MICROCODE
          *    Gen1 signaling speed (1.5Gb/s)
          *    Gen2 signaling speed (3.0Gb/s)
          *    Gen3 signaling speed (6.0Gb/s)
          *    Native Command Queueing (NCQ)
          *    Host-initiated interface power management
          *    Phy event counters
          *    NCQ priority information
               DMA Setup Auto-Activate optimization
          *    Software settings preservation
          *    SMART Command Transport (SCT) feature set
          *    SCT LBA Segment Access (AC2)
          *    SCT Features Control (AC4)
          *    SCT Data Tables (AC5)
               unknown 206[12] (vendor specific)
               unknown 206[13] (vendor specific)
Security:
       Master password revision code =3D 65534
               supported
       not     enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       more than 508min for SECURITY ERASE UNIT. more than 508min for
ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee25b5ed142
       NAA             : 5
       IEEE OUI        : 0014ee
       Unique ID       : 25b5ed142
Checksum: correct






May  3 18:18:50 relampago3 kernel: [ 3931.976021] usb 1-4: new
high-speed USB device number 4 using ehci_hcd
May  3 18:18:50 relampago3 kernel: [ 3932.108900] usb 1-4: New USB
device found, idVendor=3D152d, idProduct=3D2329
May  3 18:18:50 relampago3 kernel: [ 3932.108907] usb 1-4: New USB
device strings: Mfr=3D1, Product=3D2, SerialNumber=3D5
May  3 18:18:50 relampago3 kernel: [ 3932.108911] usb 1-4: Product:
USB to ATA/ATAPI Bridge
May  3 18:18:50 relampago3 kernel: [ 3932.108914] usb 1-4: Manufacturer: JM=
icron
May  3 18:18:50 relampago3 kernel: [ 3932.108917] usb 1-4:
SerialNumber: 152D20329000
May  3 18:18:50 relampago3 kernel: [ 3932.110324] usb-storage 1-4:1.0:
Quirks match for vid 152d pid 2329: 8020
May  3 18:18:50 relampago3 kernel: [ 3932.110360] scsi7 : usb-storage 1-4:1=
.0
May  3 18:18:50 relampago3 mtp-probe: checking bus 1, device 4:
"/sys/devices/pci0000:00/0000:00:1a.7/usb1/1-4"
May  3 18:18:50 relampago3 mtp-probe: bus: 1, device: 4 was not an MTP devi=
ce
May  3 18:18:57 relampago3 hddtemp[1872]: /dev/sda: WDC WD2500JS-75NCB3: 34=
 C
May  3 18:19:06 relampago3 kernel: [ 3948.470324] scsi 7:0:0:0:
Direct-Access     WDC WD30 EZRX-00MMMB0          PQ: 0 ANSI: 2 CCS
May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
1565565872 512-byte logical blocks: (801 GB/746 GiB)
May  3 18:19:06 relampago3 kernel: [ 3948.473541] sd 7:0:0:0: [sdf]
Write Protect is off
May  3 18:19:06 relampago3 kernel: [ 3948.473547] sd 7:0:0:0: [sdf]
Mode Sense: 34 00 00 00
May  3 18:19:06 relampago3 kernel: [ 3948.474287] sd 7:0:0:0: [sdf]
Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
May  3 18:19:06 relampago3 kernel: [ 3948.504915] Alternate GPT is
invalid, using primary GPT.
May  3 18:19:06 relampago3 kernel: [ 3948.504944]  sdf:
May  3 18:19:06 relampago3 kernel: [ 3948.507541] sd 7:0:0:0: [sdf]
Attached SCSI disk
May  3 18:19:06 relampago3 ata_id[3163]: HDIO_GET_IDENTITY failed for
'/dev/sdf': Invalid argument




fdisk: opci=F3n inv=E1lida -- c
GNU Fdisk 1.2.4
Copyright (C) 1998 - 2006 Free Software Foundation, Inc.
This program is free software, covered by the GNU General Public License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

Error: The backup GPT table is corrupt, but the primary appears OK, so
that will be used.
  o   OK
  c   Cancel
o
Error: Can't have a partition outside the disk!

--f46d042e005f6e085a04d3ab15a9
Content-Type: application/octet-stream; name=syslogtail
Content-Disposition: attachment; filename=syslogtail
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1s36egg0

TWF5ICAzIDE4OjE4OjUwIHJlbGFtcGFnbzMga2VybmVsOiBbIDM5MzEuOTc2MDIxXSB1c2IgMS00
OiBuZXcgaGlnaC1zcGVlZCBVU0IgZGV2aWNlIG51bWJlciA0IHVzaW5nIGVoY2lfaGNkCk1heSAg
MyAxODoxODo1MCByZWxhbXBhZ28zIGtlcm5lbDogWyAzOTMyLjEwODkwMF0gdXNiIDEtNDogTmV3
IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTE1MmQsIGlkUHJvZHVjdD0yMzI5Ck1heSAgMyAx
ODoxODo1MCByZWxhbXBhZ28zIGtlcm5lbDogWyAzOTMyLjEwODkwN10gdXNiIDEtNDogTmV3IFVT
QiBkZXZpY2Ugc3RyaW5nczogTWZyPTEsIFByb2R1Y3Q9MiwgU2VyaWFsTnVtYmVyPTUKTWF5ICAz
IDE4OjE4OjUwIHJlbGFtcGFnbzMga2VybmVsOiBbIDM5MzIuMTA4OTExXSB1c2IgMS00OiBQcm9k
dWN0OiBVU0IgdG8gQVRBL0FUQVBJIEJyaWRnZQpNYXkgIDMgMTg6MTg6NTAgcmVsYW1wYWdvMyBr
ZXJuZWw6IFsgMzkzMi4xMDg5MTRdIHVzYiAxLTQ6IE1hbnVmYWN0dXJlcjogSk1pY3JvbgpNYXkg
IDMgMTg6MTg6NTAgcmVsYW1wYWdvMyBrZXJuZWw6IFsgMzkzMi4xMDg5MTddIHVzYiAxLTQ6IFNl
cmlhbE51bWJlcjogMTUyRDIwMzI5MDAwCk1heSAgMyAxODoxODo1MCByZWxhbXBhZ28zIGtlcm5l
bDogWyAzOTMyLjExMDMyNF0gdXNiLXN0b3JhZ2UgMS00OjEuMDogUXVpcmtzIG1hdGNoIGZvciB2
aWQgMTUyZCBwaWQgMjMyOTogODAyMApNYXkgIDMgMTg6MTg6NTAgcmVsYW1wYWdvMyBrZXJuZWw6
IFsgMzkzMi4xMTAzNjBdIHNjc2k3IDogdXNiLXN0b3JhZ2UgMS00OjEuMApNYXkgIDMgMTg6MTg6
NTAgcmVsYW1wYWdvMyBtdHAtcHJvYmU6IGNoZWNraW5nIGJ1cyAxLCBkZXZpY2UgNDogIi9zeXMv
ZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWEuNy91c2IxLzEtNCIKTWF5ICAzIDE4OjE4OjUw
IHJlbGFtcGFnbzMgbXRwLXByb2JlOiBidXM6IDEsIGRldmljZTogNCB3YXMgbm90IGFuIE1UUCBk
ZXZpY2UKTWF5ICAzIDE4OjE4OjU3IHJlbGFtcGFnbzMgaGRkdGVtcFsxODcyXTogL2Rldi9zZGE6
IFdEQyBXRDI1MDBKUy03NU5DQjM6IDM0IEMKTWF5ICAzIDE4OjE5OjA2IHJlbGFtcGFnbzMga2Vy
bmVsOiBbIDM5NDguNDcwMzI0XSBzY3NpIDc6MDowOjA6IERpcmVjdC1BY2Nlc3MgICAgIFdEQyBX
RDMwIEVaUlgtMDBNTU1CMCAgICAgICAgICBQUTogMCBBTlNJOiAyIENDUwpNYXkgIDMgMTg6MTk6
MDYgcmVsYW1wYWdvMyBrZXJuZWw6IFsgMzk0OC40NzI3OTZdIHNkIDc6MDowOjA6IFtzZGZdIDE1
NjU1NjU4NzIgNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICg4MDEgR0IvNzQ2IEdpQikKTWF5ICAz
IDE4OjE5OjA2IHJlbGFtcGFnbzMga2VybmVsOiBbIDM5NDguNDczNTQxXSBzZCA3OjA6MDowOiBb
c2RmXSBXcml0ZSBQcm90ZWN0IGlzIG9mZgpNYXkgIDMgMTg6MTk6MDYgcmVsYW1wYWdvMyBrZXJu
ZWw6IFsgMzk0OC40NzM1NDddIHNkIDc6MDowOjA6IFtzZGZdIE1vZGUgU2Vuc2U6IDM0IDAwIDAw
IDAwCk1heSAgMyAxODoxOTowNiByZWxhbXBhZ28zIGtlcm5lbDogWyAzOTQ4LjQ3NDI4N10gc2Qg
NzowOjA6MDogW3NkZl0gV3JpdGUgY2FjaGU6IGRpc2FibGVkLCByZWFkIGNhY2hlOiBlbmFibGVk
LCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQpNYXkgIDMgMTg6MTk6MDYgcmVsYW1wYWdvMyBr
ZXJuZWw6IFsgMzk0OC41MDQ5MTVdIEFsdGVybmF0ZSBHUFQgaXMgaW52YWxpZCwgdXNpbmcgcHJp
bWFyeSBHUFQuCk1heSAgMyAxODoxOTowNiByZWxhbXBhZ28zIGtlcm5lbDogWyAzOTQ4LjUwNDk0
NF0gIHNkZjoKTWF5ICAzIDE4OjE5OjA2IHJlbGFtcGFnbzMga2VybmVsOiBbIDM5NDguNTA3NTQx
XSBzZCA3OjA6MDowOiBbc2RmXSBBdHRhY2hlZCBTQ1NJIGRpc2sKTWF5ICAzIDE4OjE5OjA2IHJl
bGFtcGFnbzMgYXRhX2lkWzMxNjNdOiBIRElPX0dFVF9JREVOVElUWSBmYWlsZWQgZm9yICcvZGV2
L3NkZic6IEludmFsaWQgYXJndW1lbnQKCg==
--f46d042e005f6e085a04d3ab15a9
Content-Type: application/octet-stream; name=fdisk
Content-Disposition: attachment; filename=fdisk
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1s36ks71

ZmRpc2s6IG9wY2nDs24gaW52w6FsaWRhIC0tIGMKR05VIEZkaXNrIDEuMi40CkNvcHlyaWdodCAo
QykgMTk5OCAtIDIwMDYgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLCBJbmMuClRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlLCBjb3ZlcmVkIGJ5IHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGlj
ZW5zZS4KClRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdp
bGwgYmUgdXNlZnVsLApidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUg
aW1wbGllZCB3YXJyYW50eSBvZgpNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJU
SUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCkdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBt
b3JlIGRldGFpbHMuCgpFcnJvcjogVGhlIGJhY2t1cCBHUFQgdGFibGUgaXMgY29ycnVwdCwgYnV0
IHRoZSBwcmltYXJ5IGFwcGVhcnMgT0ssIHNvIHRoYXQgd2lsbCBiZSB1c2VkLgogICBvICAgT0sg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIAogICBjICAgQ2FuY2VsCm8KRXJyb3I6IENhbid0IGhhdmUgYSBwYXJ0aXRpb24gb3V0
c2lkZSB0aGUgZGlzayEK
--f46d042e005f6e085a04d3ab15a9
Content-Type: application/octet-stream; name=hdparm
Content-Disposition: attachment; filename=hdparm
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h1s36ojr2

L2Rldi9zZGY6CgpBVEEgZGV2aWNlLCB3aXRoIG5vbi1yZW1vdmFibGUgbWVkaWEKCU1vZGVsIE51
bWJlcjogICAgICAgV0RDIFdEMzBFWlJYLTAwTU1NQjAgICAgICAgICAgICAgICAgICAgIAoJU2Vy
aWFsIE51bWJlcjogICAgICBXRC1XQ0FXWnh4eHh4eHgKCUZpcm13YXJlIFJldmlzaW9uOiAgODAu
MDBBODAKCVRyYW5zcG9ydDogICAgICAgICAgU2VyaWFsLCBTQVRBIDEuMGEsIFNBVEEgSUkgRXh0
ZW5zaW9ucywgU0FUQSBSZXYgMi41LCBTQVRBIFJldiAyLjYsIFNBVEEgUmV2IDMuMApTdGFuZGFy
ZHM6CglTdXBwb3J0ZWQ6IDggNyA2IDUgCglMaWtlbHkgdXNlZDogOApDb25maWd1cmF0aW9uOgoJ
TG9naWNhbAkJbWF4CWN1cnJlbnQKCWN5bGluZGVycwkxNjM4MwkxNjM4MwoJaGVhZHMJCTE2CTE2
CglzZWN0b3JzL3RyYWNrCTYzCTYzCgktLQoJQ0hTIGN1cnJlbnQgYWRkcmVzc2FibGUgc2VjdG9y
czogICAxNjUxNDA2NAoJTEJBICAgIHVzZXIgYWRkcmVzc2FibGUgc2VjdG9yczogIDI2ODQzNTQ1
NQoJTEJBNDggIHVzZXIgYWRkcmVzc2FibGUgc2VjdG9yczogNTg2MDUzMzE2OAoJTG9naWNhbCAg
U2VjdG9yIHNpemU6ICAgICAgICAgICAgICAgICAgIDUxMiBieXRlcwoJUGh5c2ljYWwgU2VjdG9y
IHNpemU6ICAgICAgICAgICAgICAgICAgNDA5NiBieXRlcwoJTG9naWNhbCBTZWN0b3ItMCBvZmZz
ZXQ6ICAgICAgICAgICAgICAgICAgMCBieXRlcwoJZGV2aWNlIHNpemUgd2l0aCBNID0gMTAyNCox
MDI0OiAgICAgMjg2MTU4OCBNQnl0ZXMKCWRldmljZSBzaXplIHdpdGggTSA9IDEwMDAqMTAwMDog
ICAgIDMwMDA1OTIgTUJ5dGVzICgzMDAwIEdCKQoJY2FjaGUvYnVmZmVyIHNpemUgID0gdW5rbm93
bgpDYXBhYmlsaXRpZXM6CglMQkEsIElPUkRZKGNhbiBiZSBkaXNhYmxlZCkKCVF1ZXVlIGRlcHRo
OiAzMgoJU3RhbmRieSB0aW1lciB2YWx1ZXM6IHNwZWMnZCBieSBTdGFuZGFyZCwgd2l0aCBkZXZp
Y2Ugc3BlY2lmaWMgbWluaW11bQoJUi9XIG11bHRpcGxlIHNlY3RvciB0cmFuc2ZlcjogTWF4ID0g
MTYJQ3VycmVudCA9IDAKCURNQTogbWRtYTAgbWRtYTEgbWRtYTIgdWRtYTAgdWRtYTEgdWRtYTIg
dWRtYTMgdWRtYTQgdWRtYTUgKnVkbWE2IAoJICAgICBDeWNsZSB0aW1lOiBtaW49MTIwbnMgcmVj
b21tZW5kZWQ9MTIwbnMKCVBJTzogcGlvMCBwaW8xIHBpbzIgcGlvMyBwaW80IAoJICAgICBDeWNs
ZSB0aW1lOiBubyBmbG93IGNvbnRyb2w9MTIwbnMgIElPUkRZIGZsb3cgY29udHJvbD0xMjBucwpD
b21tYW5kcy9mZWF0dXJlczoKCUVuYWJsZWQJU3VwcG9ydGVkOgoJICAgKglTTUFSVCBmZWF0dXJl
IHNldAoJICAgIAlTZWN1cml0eSBNb2RlIGZlYXR1cmUgc2V0CgkgICAqCVBvd2VyIE1hbmFnZW1l
bnQgZmVhdHVyZSBzZXQKCSAgICoJV3JpdGUgY2FjaGUKCSAgICoJTG9vay1haGVhZAoJICAgKglI
b3N0IFByb3RlY3RlZCBBcmVhIGZlYXR1cmUgc2V0CgkgICAqCVdSSVRFX0JVRkZFUiBjb21tYW5k
CgkgICAqCVJFQURfQlVGRkVSIGNvbW1hbmQKCSAgICoJTk9QIGNtZAoJICAgKglET1dOTE9BRF9N
SUNST0NPREUKCSAgICAJUG93ZXItVXAgSW4gU3RhbmRieSBmZWF0dXJlIHNldAoJICAgKglTRVRf
RkVBVFVSRVMgcmVxdWlyZWQgdG8gc3BpbnVwIGFmdGVyIHBvd2VyIHVwCgkgICAgCVNFVF9NQVgg
c2VjdXJpdHkgZXh0ZW5zaW9uCgkgICAqCTQ4LWJpdCBBZGRyZXNzIGZlYXR1cmUgc2V0CgkgICAq
CURldmljZSBDb25maWd1cmF0aW9uIE92ZXJsYXkgZmVhdHVyZSBzZXQKCSAgICoJTWFuZGF0b3J5
IEZMVVNIX0NBQ0hFCgkgICAqCUZMVVNIX0NBQ0hFX0VYVAoJICAgKglTTUFSVCBlcnJvciBsb2dn
aW5nCgkgICAqCVNNQVJUIHNlbGYtdGVzdAoJICAgKglHZW5lcmFsIFB1cnBvc2UgTG9nZ2luZyBm
ZWF0dXJlIHNldAoJICAgKgk2NC1iaXQgV29ybGQgd2lkZSBuYW1lCgkgICAqCXtSRUFELFdSSVRF
fV9ETUFfRVhUX0dQTCBjb21tYW5kcwoJICAgKglTZWdtZW50ZWQgRE9XTkxPQURfTUlDUk9DT0RF
CgkgICAqCUdlbjEgc2lnbmFsaW5nIHNwZWVkICgxLjVHYi9zKQoJICAgKglHZW4yIHNpZ25hbGlu
ZyBzcGVlZCAoMy4wR2IvcykKCSAgICoJR2VuMyBzaWduYWxpbmcgc3BlZWQgKDYuMEdiL3MpCgkg
ICAqCU5hdGl2ZSBDb21tYW5kIFF1ZXVlaW5nIChOQ1EpCgkgICAqCUhvc3QtaW5pdGlhdGVkIGlu
dGVyZmFjZSBwb3dlciBtYW5hZ2VtZW50CgkgICAqCVBoeSBldmVudCBjb3VudGVycwoJICAgKglO
Q1EgcHJpb3JpdHkgaW5mb3JtYXRpb24KCSAgICAJRE1BIFNldHVwIEF1dG8tQWN0aXZhdGUgb3B0
aW1pemF0aW9uCgkgICAqCVNvZnR3YXJlIHNldHRpbmdzIHByZXNlcnZhdGlvbgoJICAgKglTTUFS
VCBDb21tYW5kIFRyYW5zcG9ydCAoU0NUKSBmZWF0dXJlIHNldAoJICAgKglTQ1QgTEJBIFNlZ21l
bnQgQWNjZXNzIChBQzIpCgkgICAqCVNDVCBGZWF0dXJlcyBDb250cm9sIChBQzQpCgkgICAqCVND
VCBEYXRhIFRhYmxlcyAoQUM1KQoJICAgIAl1bmtub3duIDIwNlsxMl0gKHZlbmRvciBzcGVjaWZp
YykKCSAgICAJdW5rbm93biAyMDZbMTNdICh2ZW5kb3Igc3BlY2lmaWMpClNlY3VyaXR5OiAKCU1h
c3RlciBwYXNzd29yZCByZXZpc2lvbiBjb2RlID0gNjU1MzQKCQlzdXBwb3J0ZWQKCW5vdAllbmFi
bGVkCglub3QJbG9ja2VkCglub3QJZnJvemVuCglub3QJZXhwaXJlZDogc2VjdXJpdHkgY291bnQK
CQlzdXBwb3J0ZWQ6IGVuaGFuY2VkIGVyYXNlCgltb3JlIHRoYW4gNTA4bWluIGZvciBTRUNVUklU
WSBFUkFTRSBVTklULiBtb3JlIHRoYW4gNTA4bWluIGZvciBFTkhBTkNFRCBTRUNVUklUWSBFUkFT
RSBVTklULiAKTG9naWNhbCBVbml0IFdXTiBEZXZpY2UgSWRlbnRpZmllcjogNTAwMTRlZTI1YjVl
ZDE0MgoJTkFBCQk6IDUKCUlFRUUgT1VJCTogMDAxNGVlCglVbmlxdWUgSUQJOiAyNWI1ZWQxNDIK
Q2hlY2tzdW06IGNvcnJlY3QKCg==
--f46d042e005f6e085a04d3ab15a9--
