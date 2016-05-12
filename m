From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/2] Fix efi_call
Date: Thu, 12 May 2016 12:43:46 +0100
Message-ID: <20160512114346.GE2728@codeblueprint.co.uk>
References: <1462996545-98387-1-git-send-email-athorlton@sgi.com>
 <1462996545-98387-3-git-send-email-athorlton@sgi.com>
 <20160512064835.GB30717@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160512064835.GB30717@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-kernel@vger.kernel.org, Dimitri Sivanich <sivanich@sgi.com>, Russ Anderson <rja@sgi.com>, Mike Travis <travis@sgi.com>, Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Thu, 12 May, at 08:48:35AM, Ingo Molnar wrote:
> 
> * Alex Thorlton <athorlton@sgi.com> wrote:
> 
> > The efi_call assembly code has a slight error that prevents us from
> > using arguments 7 and higher, which will be passed in on the stack.
> > 
> >         mov (%rsp), %rax
> >         mov 8(%rax), %rax
> > 	...
> >         mov %rax, 40(%rsp)
> > 
> > This code goes and grabs the return address for the current stack frame,
> > and puts it on the stack, next the 5th argument for the EFI runtime
> > call.  Considering the fact that having the return address in that
> > position on the stack makes no sense, I'm guessing that the intent of
> > this code was actually to grab an argument off the stack frame for this
> > call and place it into the frame for the next one.
> > 
> > The small change to that offset (i.e. 8(%rax) to 16(%rax)) ensures that
> > we grab the 7th argument off the stack, and pass it as the 6th argument
> > to the EFI runtime function that we're about to call.  This change gets
> > our EFI runtime calls that need to pass more than 6 arguments working
> > again.
> 
> I suppose the SGI/UV code is the only one using 7 arguments or more? Might make 
> sense to point that out in the changelog.
 
Yeah, I included that info when I applied this patch.
