From: "Rafael J. Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 11/24] uswsusp: Disable when the kernel is locked down
Date: Thu, 6 Apr 2017 22:07:50 +0200
Message-ID: <CAJZ5v0iZ7Wf5pWL9HSzH_0djQfDmCLT14sp0HYbs9h8UuGHPkQ@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142336965.5101.2946578135980499557.stgit@warthog.procyon.org.uk>
 <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com> <10055.1491461713@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <10055.1491461713@warthog.procyon.org.uk>
Sender: linux-pm-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux PM <linux-pm@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 6, 2017 at 8:55 AM, David Howells <dhowells@redhat.com> wrote:
> Rafael J. Wysocki <rafael@kernel.org> wrote:
>
>> You probably want to disable hibernation altogether in this case.
>
> See patch 10.  Does that mean patch 11 is superfluous?

Yes, it does.

You can't open /dev/snapshot if hibernation_available() returns false.

Thanks,
Rafael
