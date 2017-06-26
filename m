From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v7 34/36] x86/mm: Add support to encrypt the kernel
 in-place
Date: Mon, 26 Jun 2017 17:45:43 +0200
Message-ID: <20170626154543.fsuxfhxidytgo2ia@pd.tnic>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
 <20170616185619.18967.38945.stgit@tlendack-t1.amdoffice.net>
 <20170623100013.upd4or6esjvulmvg@pd.tnic>
 <af9a50f7-17ea-a840-6456-b6479e5d7e82@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <af9a50f7-17ea-a840-6456-b6479e5d7e82-5C7GfCeVMHo@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Cc: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dy>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 23, 2017 at 12:44:46PM -0500, Tom Lendacky wrote:
> Normally the __p4d() macro would be used and that would be ok whether
> CONFIG_X86_5LEVEL is defined or not. But since __p4d() is part of the
> paravirt ops path I have to use native_make_p4d().

So __p4d is in !CONFIG_PARAVIRT path.

Regardless, we use the native_* variants in generic code to mean, not
paravirt. Just define it in a separate patch like the rest of the p4*
machinery and use it in your code. Sooner or later someone else will
need it.

> True, 5-level will only be turned on for specific hardware which is why
> I originally had this as only 4-level pagetables. But in a comment from
> you back on the v5 version you said it needed to support 5-level. I
> guess we should have discussed this more,

AFAIR, I said something along the lines of "what about 5-level page
tables?" and whether we care.

> but I also thought that should our hardware ever support 5-level
> paging in the future then this would be good to go.

There it is :-)

> The macros work great if you are not running identity mapped. You could
> use p*d_offset() to move easily through the tables, but those functions
> use __va() to generate table virtual addresses. I've seen where
> boot/compressed/pagetable.c #defines __va() to work with identity mapped
> pages but that would only work if I create a separate file just for this
> function.
> 
> Given when this occurs it's very similar to what __startup_64() does in
> regards to the IS_ENABLED(CONFIG_X86_5LEVEL) checks.

Ok.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
