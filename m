From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Fwd: 2TB USB hard drive for backing up
Date: Mon, 21 Jan 2013 15:21:38 -0600
Message-ID: <50FDB162.2040209@zytor.com>
References: <jmunm9$90r$2@speranza.aioe.org> <201204301814.21525.Martin@lichtvoll.de> <CAGZeNoc82T0jS=Sg3d2umqi6PjAWjOKjqK2RbuK+QfAzN3Pmww@mail.gmail.com> <201205010044.24643.Martin@lichtvoll.de> <CAGZeNoeSEtTMK22+JcsG7xRRrbsQwgJV5iLgWenrX=rvLr-ZXQ@mail.gmail.com> <CAGZeNof6NWiXhCDPpZiLu8QhQ_6Cmp-nhSOf=h=-jAjccWaa7g@mail.gmail.com> <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ellwood Blues <elwood.blue@gmail.com>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 01/19/2013 03:40 PM, Ellwood Blues wrote:
> Hi.
> 
> I've had this problem for so long that today after compiling kernel
> 3.7.3 and not getting any improvements I decided to let you know that
> some of us still only able to use our GPT 3TB hard disks only on
> Windows.
> 
> On linux only hdparm and gdisk see 3TB but also see some kind of
> corruption on the alternate GPT which is not true because on windows
> works flawlessly.
> 
> I hope you won't take too long to make it work because this is the
> only reason I still loging in on windows, before buying this disk I
> didn't log in on windows at all.
> 
> I don't need the EFI drivers to work because the BIOS is not ready for
> that, I only would like to read and write on the disk which is already
> half full and cannot do any new experiments trying to fix it with
> gdisk.
> 
> I only need the kernel GPT drivers to work out.
> 

This has nothing to do with GPT.  The problem is that the capacity
reported by the drive is truncated:

May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
1565565872 512-byte logical blocks: (801 GB/746 GiB)

Is the hdparm produced via the USB interface or by plugging the internal
drive into an SATA/eSATA port?

Either way... it is offtopic for the linux-efi mailing list.

	-hpa
