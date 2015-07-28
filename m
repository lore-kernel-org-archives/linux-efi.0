From: Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC PATCH 00/16] Signature verification of hibernate snapshot
Date: Tue, 28 Jul 2015 13:09:23 +0100
Message-ID: <1438085363.2923.8.camel@intel.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
	 <alpine.LNX.2.00.1507241527410.1141@pobox.suse.cz>
	 <7508149.lVtoIPoiay@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <7508149.lVtoIPoiay@vostro.rjw.lan>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiri Kosina <jkosina@suse.com>, "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

On Fri, 2015-07-24 at 22:08 +0200, Rafael J. Wysocki wrote:
> On Friday, July 24, 2015 07:08:18 PM Jiri Kosina wrote:
> > On Thu, 16 Jul 2015, Lee, Chun-Yi wrote:
> > 
> > > This patchset is the implementation of signature verification of hibernate
> > > snapshot image. The origin idea is from Jiri Kosina: Let EFI bootloader
> > > generate key-pair in UEFI secure boot environment, then forward it to kernel
> > > for sign/verify hibernate image.
> > 
> > I've finally managed to fully go through the series and test it on my 
> > secure boot testing setup.
> > 
> > 	Reviewed-by: Jiri Kosina <jkosina@suse.com>
> > 	Tested-by: Jiri Kosina <jkosina@suse.com>
> > 
> > for the whole series. Thanks,
> 
> Thanks Jiri, much appreciated!
> 
> I'd like to hear from Matt, though, and it looks like Ingo han't been CCed ...

I'm hoping to get time to review this series this week.

