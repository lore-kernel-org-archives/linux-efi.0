From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Thu, 14 Nov 2013 10:26:23 -0500
Message-ID: <20131114152623.GC3913@redhat.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com>
 <52840206.5020006@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52840206.5020006-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: jerry.hoemann-VXdhtT5mjnY@public.gmane.org, rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 13, 2013 at 02:49:42PM -0800, H. Peter Anvin wrote:

[..]
> In other words, allocating the crashkernel high has ALL the advantages,
> plus a few more, and NONE of the disadvantages.

It allocates low memory for swiotlb. So that extra 72M allocation is the
disadvantage. With so many virtual machines on a single host, I don't
want to reserve extra 72MB on each virtual machine while I could
easily do away with memory reservation below 4G. 

So I do think that first trying memory below 896M, then below 4G and then
above 4G makes sense and we should modify crashkernel=X to handle that.

Thanks
Vivek
