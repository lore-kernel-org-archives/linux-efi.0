From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 8/8] efi: Add EFI_SECURE_BOOT bit [ver #6]
Date: Mon, 16 Jan 2017 13:40:41 +0000
Message-ID: <20170116134041.GA27351@codeblueprint.co.uk>
References: <20170111145138.GB29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120026820.5854.13036556358308461345.stgit@warthog.procyon.org.uk>
 <7979.1484148564@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7979.1484148564@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Wed, 11 Jan, at 03:29:24PM, David Howells wrote:
> Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > Before we add more efi.flags bits I'd like this series to include the
> > patch that makes use of EFI_SECURE_BOOT. Alternatively, you move this
> > last patch to a new series.
> 
> Are you willing to take the kernel lock-down patches also?

I'm happy to take them through the EFI tree provided that they've been
Reviewed/Ack-ed by the security folks.
