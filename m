From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/2] Secure Boot: More controversial changes
Date: Mon, 28 Jan 2013 18:05:56 -0800
Message-ID: <51072E84.4080509@zytor.com>
References: <1359391662-26120-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359391662-26120-1-git-send-email-matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/28/2013 08:47 AM, Matthew Garrett wrote:
> These patches break functionality that people rely on without providing
> any functional equivalent, so I'm not suggesting that they be merged
> as-is. kexec allows trivial circumvention of the trust model (it's
> trivially equivalent to permitting module loading, for instance) and
> hibernation allows similar attacks (disable swap, write a pre-formed resume
> image to swap, reboot). The hibernation patch also shows up a different
> issue - some userspace drops all capabilities, resulting in things that
> userspace expects to work no longer working. This seems like an
> unsurprising result, but breaking userspace is bad and so it'd be nice to
> figure out if there's another way to handle this.

These at the very least need some kind of CONFIG_WEAK_SECURE_BOOT option 
or something like that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
