From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: EFI mode after running kexec
Date: Sat, 31 Aug 2013 06:52:44 +0200
Message-ID: <20130831045244.GA12617@x1.alien8.de>
References: <20130829022632.GA26862@kroah.com>
 <CA+5PVA7jec5DAxgKachkBw1VFobz4rVMQwcqzYQ7ynk7=+d+zg@mail.gmail.com>
 <1377779723.2223.105.camel@dabdike>
 <20130829192001.GB11624@kroah.com>
 <5220CBEE.20706@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5220CBEE.20706-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 30, 2013 at 09:44:30AM -0700, H. Peter Anvin wrote:
> I and Borislav actually came up with a reasonable solution for SVAM().
> It sadly creates a new ABI, but at least is (a) reasonable and (b)
> seems to match Windows close enough. Basically the regions should get
> mapped one by one from -4 GB downwards.

Yep, and the mapping works both on OVMF and on my baremetal box. I'm
currently on vacation but will send out the final stuff when I get back.

Teaching the kexec-ed kernel to simply use those mappings *without*
doing SVAM() should be easy afterwards.

Thanks.

-- 
Regards/Gruss,
Boris.
