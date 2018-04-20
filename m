From: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v3 3/5] platform/x86: Rename silead_dmi to touchscreen_dmi
Date: Thu, 19 Apr 2018 17:20:30 -0700
Message-ID: <20180420002030.GD11546@fury>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-4-hdegoede@redhat.com>
 <CAHp75Vdx0fJ0mmE1tSZjKEoHbRMubJpA8M1QYg1joKxMdLcVig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHp75Vdx0fJ0mmE1tSZjKEoHbRMubJpA8M1QYg1joKxMdLcVig@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Andy Shevchenko <andy@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Platform Driver <platform-driver-x86@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov>
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 09, 2018 at 11:07:03AM +0300, Andy Shevchenko wrote:
> On Sun, Apr 8, 2018 at 8:40 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> > Not only silead touchscreens need some extra info not available in the
> > ACPI tables to work properly. X86 devices with a Chipone ICN8505 chip also
> > need some DMI based extra configuration.
> >
> > There is no reason to have separate dmi config code per touchscreen
> > controller vendor. This commit renames silead_dmi to a more generic
> > touchscreen_dmi name (and Kconfig option) in preparation of adding
> > info for tablets with an ICN8505 based touchscreen.
> >
> > Note there are no functional changes all code changes are limited to
> > removing references to silead where these are no longer applicable.
> >
> 
> I have no objections from my side, though consider the following:
> - I would like to be in sync with Darren on this
> - make oldconfig will be broken after your change for existing users
> - the usual pattern in kernel that we don't rename drivers; I guess
> here we are on the safe side b/c this driver is used standalone
> 
> Taking above into attention, and assuming it will go via some other tree,
> Acked-by: Andy Shevchenko <andy.shevchenko@gmail.com>

This driver is all kinds of a special case, so no objection here either. :-)

-- 
Darren Hart
VMware Open Source Technology Center
