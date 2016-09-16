From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] efi: Format EFI version prints the way the standard
 says.
Date: Fri, 16 Sep 2016 10:42:57 -0400
Message-ID: <20160916144256.rnjc3pc2oj7zbp4k@redhat.com>
References: <20160907122339.GB28333@wunner.de>
 <1473260186-4500-1-git-send-email-pjones@redhat.com>
 <1473260186-4500-3-git-send-email-pjones@redhat.com>
 <20160915091822.GA16797@codeblueprint.co.uk>
 <20160915131305.5mhdpc6vql5nv2gw@redhat.com>
 <20160916094006.GD16797@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160916094006.GD16797-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Sep 16, 2016 at 10:40:06AM +0100, Matt Fleming wrote:
> On Thu, 15 Sep, at 09:13:05AM, Peter Jones wrote:
> > 
> > Really I just prefer to have them say the same thing the spec does - but
> > your point is certainly valid.  Would you be happier with it if I put a
> > check in that only prints the new way for, say, revisions newer than
> > 2.6, and prints them the older way otherwise?
> 
> Because /sys/firmware/efi/spec_version is a new file, I'm totally
> happy with printing a correct version string there. There's really no
> need to maintain the version idiosyncrasy in new places.
> 
> And given the extra code required to maintain backwards compatibility
> for versions <= 2.6 but only in the boot paths, I think the simplest
> solution is to drop this patch.

Okay, that's fine by me since we now have the other interface.

-- 
        Peter
