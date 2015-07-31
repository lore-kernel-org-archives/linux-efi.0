From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH 03/16] x86/boot: Public getting random boot function
Date: Fri, 31 Jul 2015 14:50:06 +0200
Message-ID: <20150731125006.GB5728@amd>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
 <1437056730-15247-4-git-send-email-jlee@suse.com>
 <20150728122133.GA12681@amd>
 <20150731105209.GF13113@linux-rxt1.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150731105209.GF13113@linux-rxt1.site>
Sender: linux-kernel-owner@vger.kernel.org
To: joeyli <jlee@suse.com>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Fri 2015-07-31 18:52:09, joeyli wrote:
> On Tue, Jul 28, 2015 at 02:21:33PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > >  int cmdline_find_option_bool(const char *option);
> > >  #endif
> > >  
> > > +#if CONFIG_RANDOMIZE_BASE
> > 
> > Not ifdef?
> > 
> > > +extern u16 i8254(void);
> > 
> > That's rather poor name for global function...
> 
> This i8254 function only used by aslr and efi_random.
> I will keep this name for do not change codes in aslr for naming.

No. That's not suitable function name for global function. And you are
making it global.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
