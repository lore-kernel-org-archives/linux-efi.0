From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 06/16] x86/efi: Generating random HMAC key for siging
 hibernate image
Date: Tue, 28 Jul 2015 14:30:26 +0200
Message-ID: <20150728123026.GC12681@amd>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-7-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437056730-15247-7-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org


> For generating a messy number as a 20 bytes key, the codes in EFI
> stub gets u32 random number five time and every random number is
> rolling that last u32 random number as entropy.

Parse error here.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
