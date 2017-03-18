From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFC PATCH v2 14/32] x86: mm: Provide support to use memblock
 when spliting large pages
Date: Sat, 18 Mar 2017 17:37:06 +0100
Message-ID: <20170318163706.GB4231@nazgul.tnic>
References: <20170310110657.hophlog2juw5hpzz@pd.tnic>
 <cb6a9a56-2c52-d98d-3ff6-3b61d0e5875e@amd.com>
 <20170316182836.tyvxoeq56thtc4pd@pd.tnic>
 <ec134379-6a48-905c-26e4-f6f2738814dc@redhat.com>
 <20170317101737.icdois7sdmtutt6b@pd.tnic>
 <b6f9f46c-58c4-a19c-4955-2d07bd411443@redhat.com>
 <20170317105610.musvo4baokgssvye@pd.tnic>
 <78c99889-f175-f60f-716b-34a62203418a@redhat.com>
 <20170317113337.syvpat3c4s2l4nuz@pd.tnic>
 <b516a873-029a-b20a-3c43-d8bf4a200cb7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b516a873-029a-b20a-3c43-d8bf4a200cb7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, simon.guinot-jKBdWWKqtFpg9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, gary.hook-5C7GfCeVMHo@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, piotr.luc-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, thomas.lendacky-5C7GfCeVMHo@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, toshi.kani-ZPxbGqLxI0U@public.gmane.org, mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 17, 2017 at 03:45:26PM +0100, Paolo Bonzini wrote:
> Yes, and I'd like that to be done with a new data section rather than a
> special KVM hook.

Can you give more details about how pls? Or is there already an example for that
somewhere in the kvm code?

> I have no idea.  SEV-ES seems to be very hard to set up at the beginning
> of the kernel bootstrap.  There's all sorts of chicken and egg problems,
> as well as complicated handshakes between the firmware and the guest,
> and the way to do it also depends on the trust and threat models.
> 
> A much simpler way is to just boot under a trusted hypervisor, do
> "modprobe sev-es" and save a snapshot of the guest.  Then you sign the
> snapshot and pass it to your cloud provider.

Right, especially the early trapping could be a pain. I don't think this
is cast in stone yet, though...

We'll see.

Thanks.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
