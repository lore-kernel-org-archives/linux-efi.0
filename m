From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Sun, 16 Nov 2014 10:22:05 -0800
Message-ID: <20141116182205.GB5032@thin>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
 <CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
 <1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
 <CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
 <CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
 <CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-sparse-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
Sender: linux-sparse-owner@vger.kernel.org
To: Christopher Li <sparse@chrisli.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, "fengguang.wu" <fengguang.wu@intel.com>
List-Id: linux-efi@vger.kernel.org

On Sun, Nov 16, 2014 at 06:13:28PM +0800, Christopher Li wrote:
> On Wed, Nov 12, 2014 at 11:34 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > Well, I spent some time playing around with this:
> >
> > This one is accepted:
> >
> > static __attribute__((__pure__)) int pure1(void)
> > {
> >     int i = 0;
> >     return i;
> > }
> >
> > This one is not accepted:
> >
> > static __attribute__((__pure__)) void *pure2(void)
> > {
> >     void *i = (void *)0;
> >     return i;
> > }
> >
> 
> Thanks for the test case. I have commit your test case with a bit more
> test case regarding function pointer assign.
> 
> The change is in chrisl repository reveiw-pure-attr branch:
> https://git.kernel.org/cgit/devel/sparse/chrisl/sparse.git/log/?h=review-pure-attr
> 
> I purpose this fix for it. It can pass your test case.
> This patch limit the pure attribute to functions.

Wait, is the above being parsed as applying the pure attribute to the
return value rather than to the function?  Or is that not the issue
here?

- Josh Triplett
