From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v3.16
Date: Sat, 19 Apr 2014 15:42:16 -0700
Message-ID: <5352FBC8.7030704@zytor.com>
References: <20140419100653.GA26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140419100653.GA26088-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/19/2014 03:06 AM, Matt Fleming wrote:
> Hi folks,
> 
> Please pull the following changes for v3.16. I'd like to get these in
> early so that they've got plenty of time to bake in linux-next. In
> particular, the ARM folks have had a hard time getting the generic EFI
> cleanups/improvements picked up via other trees.
> 
> Obviously by taking these through tip we're creating a dependency with
> whatever tree the ARM patches live in. Do we need to inform Stephen
> Rothwell explicitly of this dependency? How should we handle things when
> the v3.16 merge window opens?
> 

It doesn't hurt to inform Stephen, although I think it will simply fall
out automatically since he uses git to merge and git will recognize the
graph.

During the merge window, it means they should not push their patches
until Linus has accepted the precondition patches from the tip tree.
Since Ingo and I try to push most of the tip tree as early as possible
in the merge window, this is usually not a problem.

	-hpa
