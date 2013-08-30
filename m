From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: EFI mode after running kexec
Date: Fri, 30 Aug 2013 09:44:30 -0700
Message-ID: <5220CBEE.20706@zytor.com>
References: <20130829022632.GA26862@kroah.com> <CA+5PVA7jec5DAxgKachkBw1VFobz4rVMQwcqzYQ7ynk7=+d+zg@mail.gmail.com> <1377779723.2223.105.camel@dabdike> <20130829192001.GB11624@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130829192001.GB11624-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/29/2013 12:20 PM, Greg KH wrote:
>>
>> There's also the SetVirtualAddressMap() problem ...
> 
> Ugh, that would be a real mess...
> 

I and Borislav actually came up with a reasonable solution for SVAM().
It sadly creates a new ABI, but at least is (a) reasonable and (b) seems
to match Windows close enough.  Basically the regions should get mapped
one by one from -4 GB downwards.

	-hpa
