From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: [PATCH v8 0/2] Enable capsule loader interface for efi firmware
 updating
Date: Thu, 8 Oct 2015 03:50:27 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C4A873959@PGSMSX102.gar.corp.intel.com>
References: <1444245233-19229-1-git-send-email-hock.leong.kweh@intel.com>
 <56153352.8020704@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56153352.8020704@nexus-software.ie>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bryan O'Donoghue <pure.logic@nexus-software.ie>, Matt Fleming <matt@console-pimps.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "Fleming, Matt" <matt.fleming@intel.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
> Sent: Wednesday, October 07, 2015 11:00 PM
> 
> Wilson.
> 
> Same question as at V7. If you aren't supporting the MFH on Galileo then
> what capsule are you using with 0.75 BIOS ? From memory it won't work
> without the MFH included ...
> 
> --
> BOD

As I mentioned before the Quark Security Header patch will not upstream
to mainline and will be carried by Intel. So to test with Quark Platform, I will
apply that patch into my kernel.

Thanks & Regards,
Wilson
