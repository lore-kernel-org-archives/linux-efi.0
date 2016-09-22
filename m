From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: EFI co-maintainer
Date: Thu, 22 Sep 2016 09:34:02 +0100
Message-ID: <20160922083402.GA16071@codeblueprint.co.uk>
References: <20160921150912.GM2892@codeblueprint.co.uk>
 <20160921175951.GA3387@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160921175951.GA3387-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 21 Sep, at 07:59:51PM, Lukas Wunner wrote:
> 
> That is great to hear, thanks a lot from me as well.
> 
> Just curious, are there any plans to integrate the new repo into
> linux-next?  It would be great to have testing as early as possible.
 
Yes, the existing one is also part of linux-next once it gets merged
into tip. The issue has been that I didn't send pull requests to tip
frequently enough for that to happen on a regular basis.

Ard has already mentioned that he'd like to see that change.

> Also, if this isn't too much trouble, would it be possible to merge
> urgent into next when patches are added in the future?  When I tested
> my patches during this release cycle, I tried to pull in everything
> from efi/urgent + efi/next into my development branch but hit some
> non-trivial merge conflicts in portions of the EFI code I wasn't
> familiar with.  And ISTR that efi/next was based on 4.7, not 4.8-rc.
> In the end I just rebased my patches on efi/next, but felt a bit uneasy
> as I wasn't testing what the code would eventually look like.

This is a fair request. The only reason this hasn't happened in the
past is that no one has ever asked for it to happen regularly.

'next' and 'urgent' are intended to be topic branches, and they're
based on tags that align with their purpose - 'next' is new features
and needs a stable base and lots of testing time, whereas 'urgent' is
critical bug fixes and so needs to be based on the latest -rc.

While I don't think it makes sense to merge those branches together,
using the 'master' branch as the place with all the changes plus the
merge resolutions sounds fine to me. This is similar to how the tip
repository is structured. 

Would that work?
