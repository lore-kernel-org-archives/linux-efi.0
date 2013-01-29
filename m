From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH 0/2] Secure Boot: More controversial changes
Date: Tue, 29 Jan 2013 04:40:13 +0000
Message-ID: <20130129044013.GC14395@srcf.ucam.org>
References: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
 <51072E84.4080509@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51072E84.4080509-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 28, 2013 at 06:05:56PM -0800, H. Peter Anvin wrote:
> These at the very least need some kind of CONFIG_WEAK_SECURE_BOOT
> option or something like that.

Given Eric's views on the kexec patch (and given that there's no point 
in the hibernate one if kexec's available...), I'm not planning on 
pushing these until there's a plausible story for limiting kexec to 
signed images.

-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
