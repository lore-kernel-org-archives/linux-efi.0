From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Date: Thu, 21 Nov 2013 21:34:06 -0500
Message-ID: <20131122023406.GG31921@redhat.com>
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <528E94D1.2050809@zytor.com>
 <20131121233705.GA32121@srcf.ucam.org>
 <528EAF99.1010503@zytor.com>
 <20131122012524.GA5627@anatevka.fc.hp.com>
 <CAE9FiQUx5rnA0kpqXRQYtpj9Qk-4bPGaUKEbbF=XHsZbnSd6Rg@mail.gmail.com>
 <528EB40A.3040203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <528EB40A.3040203@zytor.com>
Sender: linux-doc-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, jerry.hoemann@hp.com, Matthew Garrett <mjg59@srcf.ucam.org>, Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo.kernel.org@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 21, 2013 at 05:31:54PM -0800, H. Peter Anvin wrote:
> On 11/21/2013 05:29 PM, Yinghai Lu wrote:
> > On Thu, Nov 21, 2013 at 5:25 PM,  <jerry.hoemann@hp.com> wrote:
> >> On Thu, Nov 21, 2013 at 05:12:57PM -0800, H. Peter Anvin wrote:
> >>
> >> Large systems w/ lots of IO require large crash kernel allocations for
> >> the kernel to boot.  Then you have to worry about the OOM killer.....
> > 
> > so go with crashkernel=1024M,high.
> > 
> 
> Yes, there is no bloody excuse to hog that much low memory.

Curious, why is low memory precious on x86_64? Who is going to use it?

Thanks
Vivek
