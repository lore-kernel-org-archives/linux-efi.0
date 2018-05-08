From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Tue, 8 May 2018 16:10:37 +0000
Message-ID: <20180508161037.GE27853@wotan.suse.de>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20180508153805.GC27853@wotan.suse.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: dmitry.torokhov@gmail.com, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, nbroeking@me.com, x86@kernel.org, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Torsten Duwe <duwe@suse.de>, Josh Triplett <josh@joshtriplett.org>, Chris Wright <chrisw@sous-sol.org>, Hans
List-Id: linux-efi@vger.kernel.org

On Tue, May 08, 2018 at 03:38:05PM +0000, Luis R. Rodriguez wrote:
> On Fri, May 04, 2018 at 12:44:37PM -0700, Martijn Coenen wrote:
> > On Wed, Apr 25, 2018 at 10:55 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > > Android became the primary user of CONFIG_FW_LOADER_USER_HELPER_FALLBACK.
> > >
> > > It would be good for us to hear from Android folks if their current use of
> > > request_firmware_into_buf() is designed in practice to *never* use the direct
> > > filesystem firmware loading interface, and always rely instead on the
> > > fallback mechanism.
> > 
> > It's hard to answer this question for Android in general. As far as I
> > can tell the reasons we use CONFIG_FW_LOADER_USER_HELPER(_FALLBACK)
> > are:
> > 1) We have multiple different paths on our devices where firmware can
> > be located, and the direct loader only supports one custom path

FWIW I'd love to consider patches to address this, if this is something
you may find a need for in the future to *avoid* the fallback, however
would like a clean solution.

> > 2) Most of those paths are not mounted by the time the corresponding
> > drivers are loaded, because pretty much all Android kernels today are
> > built without module support, and therefore drivers are loaded well
> > before the firmware partition is mounted

I've given this some more thought and you can address this with initramfs,
this is how other Linux distributions are addressing this. One way to
address this automatically is to scrape the drivers built-in or needed early on
boot in initamfs and if the driver has a MODULE_FIRMWARE() its respective
firmware is added to initramfs as well.

If you *don't* use initramfs, then yes you can obviously run into issues
where your firmware may not be accessible if the driver is somehow loaded
early.

> > 3) I think we use _FALLBACK because doing this with uevents is just
> > the easiest thing to do; our init code has a firmware helper that
> > deals with this and searches the paths that we care about
> > 
> > 2) will change at some point, because Android is moving towards a
> > model where device-specific peripheral drivers will be loaded as
> > modules, and since those modules would likely come from the same
> > partition as the firmware, it's possible that the direct load would
> > succeed (depending on whether the custom path is configured there or
> > not). But I don't think we can rely on the direct loader even in those
> > cases, unless we could configure it with multiple custom paths.

Using initramfs will help, but because of the custom path needs -- you're
right, we don't have anything for that yet, its also a bit unclear if
something nice and clean can be drawn up for it. So perhaps dealing with
the fallback mechanism is the way to go for this for sure, since we already
have support for it.

Just keep in mind that the fallback mechanism costs you about ~13436 bytes.

So, if someone comes up with a clean interface for custom paths I'd love
to consider it to avoid those 13436 bytes.

  Luis
