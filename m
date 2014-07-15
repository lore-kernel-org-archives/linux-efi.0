From: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Date: Tue, 15 Jul 2014 16:24:21 +0100
Message-ID: <53C547A5.3030500@fensystems.co.uk>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org> <20140618142819.GN24049@console-pimps.org> <20140709182651.GB15932@console-pimps.org> <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com> <20140711074029.GD5952@console-pimps.org> <20140715151025.GB32039@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715151025.GB32039-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15/07/14 16:10, Matt Fleming wrote:
> Going forward, I suspect any attempts to use the EFI File Protocol are
> going to result in this kind of breakage, and that the only thing that
> can be relied upon is the Disk I/O Protocol.
>
> But doing Disk I/O would necessitate adding the in-kernel FAT driver to
> the EFI boot stub, which is a scary idea (though not without merit).

Booting via iPXE will give you an EFI_SIMPLE_FILE_SYSTEM_PROTOCOL 
(providing access to the initrd previously downloaded by iPXE).  It will 
also give you a dummy disk I/O protocol which always return EFI_NO_MEDIA.

In those circumstances, only the EFI_SIMPLE_FILE_SYSTEM_PROTOCOL will work.

Michael
