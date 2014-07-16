From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Date: Wed, 16 Jul 2014 15:34:09 +0100
Message-ID: <20140716143409.GC32039@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
 <20140709182651.GB15932@console-pimps.org>
 <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
 <20140711074029.GD5952@console-pimps.org>
 <20140715151025.GB32039@console-pimps.org>
 <53C54C62.8070403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <53C54C62.8070403-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 15 Jul, at 08:44:34AM, H. Peter Anvin wrote:
> 
> Do we know what the Windows bootloader does?  I thought it did use the
> EFI File Protocol?

Good question. I'm not sure what the answer is, I'll try and find some
time to take a look.

-- 
Matt Fleming, Intel Open Source Technology Center
