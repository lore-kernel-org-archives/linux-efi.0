From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 10/14] efi: Make checkpatch complain less about efi.h
 GUID additions
Date: Wed, 3 Feb 2016 11:18:38 +0000
Message-ID: <20160203111838.GB2597@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-11-git-send-email-matt@codeblueprint.co.uk>
 <20160203103335.GA7310@gmail.com>
 <20160203104432.GA2597@codeblueprint.co.uk>
 <20160203105035.GB21257@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160203105035.GB21257@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 03 Feb, at 11:50:35AM, Ingo Molnar wrote:
> 
> Hm, so the GUIDs are line-broken in the same fashion in the spec, after the third 
> parameter?
 
Yep, they are.

> That's a strong reason indeed - and then the changelog and title should say that: 
> 're-format GUID tables to follow the format of the UEFI spec'. That it also 
> pacifies checkpatch is a side effect.

I think that's a fair change.

Peter could you take a look at updating the changelog in a v2? If not,
I'll do it.
