From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/4] x86/efi: print size in binary units in efi_print_memmap
Date: Sat, 23 Jan 2016 12:43:31 -0800
Message-ID: <40C32307-990E-4143-B6BB-F7AEF6CFCC81@zytor.com>
References: <1453560913-134672-1-git-send-email-andriy.shevchenko@linux.intel.com> <1453560913-134672-4-git-send-email-andriy.shevchenko@linux.intel.com> <1453567445.2470.24.camel@HansenPartnership.com> <CAHp75Vdc9=uotvaf4pQfRoViyWuEXhXjZH7GVWEG79AquPVi5A@mail.gmail.com> <1453572775.2470.56.camel@HansenPartnership.com> <20160123202926.460b284f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160123202926.460b284f-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On January 23, 2016 12:29:26 PM PST, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org> wrote:
>All a bit revisionist. Everyone else on the planet was upset about it
>because it broke things like calculating bit density because the
>prefixes
>for the bit capacity are not in metric form. BIPM (keeper of the SI
>units) never approved powers of two as an interpretation. IEC came into
>line in 1999, ISO followed.
>
>Disk sizes have been decimal since at least the 1970s. The original IBM
>10MB hard disc for example was 10MB not 10MiB.
>
>Powers of two are only validly referred to as KiB, MiB, GiB as of all
>current standard body positions. Powers of 10 based units are kB, MB,
>GB)
>
>(The best one is CD and DVD: DVD uses the proper definition, CD uses
>MiB,
>although given the multiple sector sizes and encodings on CD it's all
>manure anyway)
>
>Alan

Then there are oddball definitions like 1 MB = 1,024,000, which IBM used for disk for a long time.  At least IEC tried to come up with a unambiguous way to denote these prefixes.  It was less of an issue for kilo- since the binary prefix was always capitalized.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
