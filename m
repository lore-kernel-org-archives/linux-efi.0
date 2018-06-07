From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 7 Jun 2018 09:49:50 -0700
Message-ID: <20180607164950.GP510@tuxbook-pro>
References: <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180508161037.GE27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180508161037.GE27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Martijn Coenen <maco@android.com>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Stephen Boyd <sboyd@kernel.org>, Vikram Mulukutla <markivx@codeaurora.org>, Arve Hj?nnev?g <arve@android.com>, Todd Kjos <tkjos@android.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>, David Howells <dhowells@redhat.com>, Alan Cox <alan@linux.intel.com>, Kees Cook <keescook@chromium.org>, Hans de Goede <hdegoede@redhat.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linut>
List-Id: linux-efi@vger.kernel.org

On Tue 08 May 09:10 PDT 2018, Luis R. Rodriguez wrote:

> On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> > On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> > > On Wed, Apr 25, 2018 at 10:55 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
[..]
> > > 2) Most of those paths are not mounted by the time the corresponding
> > > drivers are loaded, because pretty much all Android kernels today are
> > > built without module support, and therefore drivers are loaded well
> > > before the firmware partition is mounted
> 
> I've given this some more thought and you can address this with initramfs,
> this is how other Linux distributions are addressing this. One way to
> address this automatically is to scrape the drivers built-in or needed early on
> boot in initamfs and if the driver has a MODULE_FIRMWARE() its respective
> firmware is added to initramfs as well.
> 

That could be done, but it would not change the fact that the
/sys/class/firmware is ABI and you may not break it.


And it doesn't change the fact that the ramdisk would have to be over
100mb to facilitate this.

> If you *don't* use initramfs, then yes you can obviously run into issues
> where your firmware may not be accessible if the driver is somehow loaded
> early.
> 

This is still a problem that lacks a solution.

> > > 3) I think we use _FALLBACK because doing this with uevents is just
> > > the easiest thing to do; our init code has a firmware helper that
> > > deals with this and searches the paths that we care about
> > > 
> > > 2) will change at some point, because Android is moving towards a
> > > model where device-specific peripheral drivers will be loaded as
> > > modules, and since those modules would likely come from the same
> > > partition as the firmware, it's possible that the direct load would
> > > succeed (depending on whether the custom path is configured there or
> > > not). But I don't think we can rely on the direct loader even in those
> > > cases, unless we could configure it with multiple custom paths.
> 
> Using initramfs will help, but because of the custom path needs -- you're
> right, we don't have anything for that yet, its also a bit unclear if
> something nice and clean can be drawn up for it. So perhaps dealing with
> the fallback mechanism is the way to go for this for sure, since we already
> have support for it.
> 
> Just keep in mind that the fallback mechanism costs you about ~13436 bytes.
> 

Remember that putting the firmware in the ramdisk would cost about
10000x (yes, ten thousand times) more ram.

> So, if someone comes up with a clean interface for custom paths I'd love
> to consider it to avoid those 13436 bytes.
> 

Combined with a way of synchronizing this with the availability of the
firmware, this would be a nice thing!

Regards,
Bjorn
