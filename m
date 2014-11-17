From: Christopher Li <sparse@chrisli.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Mon, 17 Nov 2014 08:59:03 +0800
Message-ID: <CANeU7Qnd=AoE1ty=4gTrQQh6nKYWdA2WNKwm8s+GNnU9E6XQRQ@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
	<CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
	<20141116182205.GB5032@thin>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-sparse-owner@vger.kernel.org>
In-Reply-To: <20141116182205.GB5032@thin>
Sender: linux-sparse-owner@vger.kernel.org
To: Josh Triplett <josh@joshtriplett.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, "fengguang.wu" <fengguang.wu@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 17, 2014 at 2:22 AM, Josh Triplett <josh@joshtriplett.org> wrote:
>
> Wait, is the above being parsed as applying the pure attribute to the
> return value rather than to the function?  Or is that not the issue
> here?

That seems to be the case here, e.g.  "__pure int pure1(long x);"
Currently sparse parse it as:
<node pure1>
    <function>
        <base type int>  [pure]

Ideally it should be:
<node pure1>
    <function> [pure]
        <base type int>

There is reason sparse does that. Sparse parse "__pure int" as a base
type to hold the __pure. The parse don't know if that is a function or
a function
pointer yet.

I haven't look at move the [pure] to function node. That is likely
a much bigger change.

Chris
