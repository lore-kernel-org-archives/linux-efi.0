From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: What should the default lockdown mode be if the bootloader
 sentinel triggers sanitization?
Date: Tue, 31 Jan 2017 11:57:01 +0000
Message-ID: <20170131115701.GN31613@codeblueprint.co.uk>
References: <20170123212642.GA2766@codeblueprint.co.uk>
 <20170116144954.GB27351@codeblueprint.co.uk>
 <20170111143304.GA29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
 <7948.1484148443@warthog.procyon.org.uk>
 <794.1484581158@warthog.procyon.org.uk>
 <6306.1485209503@warthog.procyon.org.uk>
 <25118.1485778229@warthog.procyon.org.uk>
 <12081.1485784892@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <12081.1485784892@warthog.procyon.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: David Howells <dhowells@redhat.com>
Cc: mjg59@srcf.ucam.org, linux-efi@vger.kernel.org, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, Michael Chang <mchang@suse.com>, linux-security-module@vger.kernel.org, Peter Jones <pjones@redhat.com>, keyrings@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Mon, 30 Jan, at 02:01:32PM, David Howells wrote:
> Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > > Matt argues, however, that boot_params->secure_boot should be propagated from
> > > the bootloader and if the bootloader wants to set it, then we should skip the
> > > check in efi_main() and go with the bootloader's opinion.  This is something
> > > we probably want to do with kexec() so that the lockdown state is propagated
> > > there.
> >  
> > Actually what I was arguing for was that if the boot loader wants to
> > set it and bypass the EFI boot stub, e.g. by going via the legacy
> > 64-bit entry point, startup_64, then we should allow that as well as
> > setting the flag in the EFI boot stub.
> 
> That brings up another question:  Should the non-EFI entry points clear the
> secure_boot mode flag and set a default?

There are no non-EFI boot entry points. EFI worked before we added the
EFI boot stub. The boot stub just provides new features (and allows us
to bundle firmware/boot fixes workarounds with kernel updates).

This is exactly why we should allow, or at least not actively
prohibit, the boot loader to set ->secure_boot and jump to the old
entry point if it wants to do that.
