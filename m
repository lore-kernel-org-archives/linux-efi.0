From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 06/16] x86/efi: Generating random HMAC key for siging
 hibernate image
Date: Fri, 31 Jul 2015 18:56:02 +0800
Message-ID: <20150731105602.GG13113@linux-rxt1.site>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-7-git-send-email-jlee@suse.com>
 <20150728123026.GC12681@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150728123026.GC12681@amd>
Sender: linux-pm-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 28, 2015 at 02:30:26PM +0200, Pavel Machek wrote:
> 
> > For generating a messy number as a 20 bytes key, the codes in EFI
> > stub gets u32 random number five time and every random number is
> > rolling that last u32 random number as entropy.
> 
> Parse error here.
>

Sorry for I didn't remove old log for developing version. I will remove it.


Thanks a lot!
Joey Lee
