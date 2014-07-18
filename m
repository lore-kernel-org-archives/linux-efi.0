From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi/arm64: handle missing virtual mapping for UEFI
 System Table
Date: Fri, 18 Jul 2014 22:18:20 +0100
Message-ID: <20140718211820.GC27099@console-pimps.org>
References: <1404487509-26084-1-git-send-email-ard.biesheuvel@linaro.org>
 <1404492756.19665.57.camel@deneb.redhat.com>
 <20140704170110.GM16404@arm.com>
 <CAKv+Gu_-=NtVNFLEh35Pv8OO6nLe1YhPjS13MYZa93YOXFOh6Q@mail.gmail.com>
 <09C85B92-02BB-45C4-A461-D4E0CD4F7203@arm.com>
 <20140707201103.GB27474@console-pimps.org>
 <CAKv+Gu9aksvu3kOVt9GAA8jGdR0DkUUJ2iT3RMS-kEZ-OOkH2w@mail.gmail.com>
 <CAKv+Gu8PW2C3=Y5+fwQbCttLp7S4a=qD5n_CRK-FM9cN84kzOA@mail.gmail.com>
 <20140718193141.GA27099@console-pimps.org>
 <CAKv+Gu-DTRi8Fjv_u_6bHCF1UTKVaok6vy3RjjvBG53Qa5wv3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-DTRi8Fjv_u_6bHCF1UTKVaok6vy3RjjvBG53Qa5wv3Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 18 Jul, at 10:11:13PM, Ard Biesheuvel wrote:
> 
> Thanks, looks lovely. The only thing I notice now is that the commit
> message from the patch below is missing the second line, which used to
> read
> 
> "#including .c files to building the "
> 
> or something to that effect. Obviously, the leading hash sign resulted
> in this line having been dropped, so this is something that has been
> in the patches all along.

Oops, that's my over-zealous patch munging. Well spotted!
 
> IMO there is really no point in bothering fixing this, but perhaps
> your inner grammar nazi disagrees.

He's a tyrant, I fixed it up, mainly because I broke it in the first
place.

-- 
Matt Fleming, Intel Open Source Technology Center
