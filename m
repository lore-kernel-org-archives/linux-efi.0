From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Subject: RE: Re: [PATCH v2 3/3] efi: Capsule update with user helper
 interface
Date: Tue, 3 Mar 2015 05:56:32 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
 <20150302122955.GB24476@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150302122955.GB24476@codeblueprint.co.uk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@amacapital.net>, Sam Protsenko <semen.protsenko@linaro.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

> -----Original Message-----
> From: Matt Fleming [mailto:matt@console-pimps.org]
> Sent: Monday, March 02, 2015 8:30 PM
> 
> On Mon, 02 Mar, at 10:59:00AM, Kweh Hock Leong wrote:
> > > -----Original Message-----
> > > From: Borislav Petkov [mailto:bp@alien8.de]
> > > Sent: Wednesday, February 25, 2015 8:49 PM
> > >
> > > On Wed, Feb 25, 2015 at 12:38:20PM +0000, Kweh, Hock Leong wrote:
> > > > The reason we use this interface for efi capsule is that efi capsule
> > > > support multi binaries to be uploaded and each binary file name
> > > > can be different.
> > >
> > > So you can write the file path to a second file and reload then, once
> > > per file.
> >
> > Thanks for the suggestion. Did some exploration on this approach and
> > would like to continue the discussion together with this suggested design.
> >
> > Ideal condition:
> > - one file note is enough for load binary and status return (capsule_load)
> > - load steps would be as simple as just:
> >    echo [binary file name] > capsule_load
> > - status return in the same command action. If failed, the echo will fail
> >    with the failing status code.
> >
> > Trade off:
> > - does not have the run time flexibility to load any firmware binaries at
> >    different different path as firmware class  only support one custom
> >    path inputted during boot time/load time. Unless to add new export
> >    function for firmware class.
> 
> Could you elaborate here? I don't understand this point.

Just to call out that using firmware class auto locate binary feature is limited
to locations:
- "/lib/firmware/updates/" UTS_RELEASE,
- "/lib/firmware/updates",
- "/lib/firmware/" UTS_RELEASE,
- "/lib/firmware"
and one custom path which inputted during firmware_class module load
time or kernel boot up time.

It is just not like the user helper interface which allow load the binary at
any path/location.

This really is not a big deal. User should cope with it.

> 
> > - if any typo on user level or file path not found, firmware class falls back
> >    to user helper interface. User is required to open another terminal to
> >    performs:
> >    -> echo 1 > loading
> >    -> cat capsule.bin > data
> >    -> echo 0 > loading
> >    Or wait for timeout.
> 
> Not if you use request_firmware_direct(), right?
> request_firmware_direct() explicitly does not invoke the user helper.
> 
> > - User has the capability to configure the firmware_class time out value.
> >    If the infinite value is set, the only method to break the infinite waiting
> >    by manually perform "echo -1 > loading" on the other terminal.
> 
> I'm not sure this is a problem if we use request_firmware_direct().

Oops... I miss out this function. Will rework using this function.

> 
> > Are you guys okay with these trade off?
> > Or you guys still okay with the previous 2 design idea?
> 
> I quite like the design that Borislav is proposing. Things become a lot
> simpler when we stop using request_firmware_nowait().
> 
> The next question is whether we want to batch passing capsules to the
> firmware. The UpdateCapsule() EFI runtime service allows you to chain
> capsule blobs together and pass a scatter-gather list.
> 
> If we do want to batch uploading then we need the equivalent of the
> 'reload' file from the microcode loader to signal to the kernel that the
> userland process has finished uploading capsules, and the kernel can now
> send them to the firmware as one chunk.
> 
> Also, Andy previously raised the point about multiple userland processes
> passing capsules to the firmware simultaneously and the races that
> occur, so we'd need a way to make that atomic.
> 
> I'd much prefer to send one capsule at a time to the firmware, because
> it just makes this whole thing simpler.
> 
> Wilson, I'm really looking for your input here with how capsule
> uploading works on Quark. If we can just repeatedly call UpdateCapsule()
> with one capsule file at a time, that's fine. If we absolutely must
> bundle multiple capsule files together then we probably need to provide
> some atomicity.
> 
> Thoughts?

Quark does not need batch uploading. Even I tested multiple capsules on
Quark by doing repeatedly calling UpdateCapsule() is still working for Quark.
So, Quark does not require this bundling.

> 
> > > Alternatively, you can combine all the files into a cpio archive like
> > > we do with the microcode loader too, and let the kernel parse the cpio
> > > archive.
> >
> > I believe this will make the implementation complicated compare to above.
> 
> Agreed. The capsule files we're sending to the firmware (via this
> interface) already contain all the information we need to stitch
> multiple binaries together - there's really no reason to bundle things
> any further.
> 
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Greg, Ming Lei, Sam & Andy,

Do you guys have any others concern on Borislav proposed approach?
Thanks.


Regards,
Wilson
