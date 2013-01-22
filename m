From: Ellwood Blues <elwood.blue@gmail.com>
Subject: Re: Fwd: 2TB USB hard drive for backing up
Date: Tue, 22 Jan 2013 10:27:52 +0000
Message-ID: <CAGZeNoe4mg57bTPzBRWKfZ47gNdeBNvq3TxjHbHAMHYEGyQZmg@mail.gmail.com>
References: <jmunm9$90r$2@speranza.aioe.org>
	<201204301814.21525.Martin@lichtvoll.de>
	<CAGZeNoc82T0jS=Sg3d2umqi6PjAWjOKjqK2RbuK+QfAzN3Pmww@mail.gmail.com>
	<201205010044.24643.Martin@lichtvoll.de>
	<CAGZeNoeSEtTMK22+JcsG7xRRrbsQwgJV5iLgWenrX=rvLr-ZXQ@mail.gmail.com>
	<CAGZeNof6NWiXhCDPpZiLu8QhQ_6Cmp-nhSOf=h=-jAjccWaa7g@mail.gmail.com>
	<CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com>
	<50FDB162.2040209@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50FDB162.2040209@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

2013/1/21 H. Peter Anvin <hpa@zytor.com>:

> This has nothing to do with GPT.  The problem is that the capacity
> reported by the drive is truncated:
>
> May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
> 1565565872 512-byte logical blocks: (801 GB/746 GiB)
>
> Is the hdparm produced via the USB interface or by plugging the internal
> drive into an SATA/eSATA port?



USB SATA docking station which works out very well on windows.



>
> Either way... it is offtopic for the linux-efi mailing list.



Sorry! I didn't know this was a list I thought it was the developer
email address.

I think that linux-efi is the most appropriate one to send this
message because GPT is included in EFI modules, I didn't see any other
about GPT.

Cheers.
