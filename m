From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 11/24] uswsusp: Disable when the kernel is locked down
Date: Thu, 06 Apr 2017 07:55:13 +0100
Message-ID: <10055.1491461713@warthog.procyon.org.uk>
References: <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com> <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk> <149142336965.5101.2946578135980499557.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <CAJZ5v0hp=GJtQ+YnNdaMw6rtbBzNyueY+iqjPkHLKp57t822ZQ@mail.gmail.com>
Content-ID: <10054.1491461713.1@warthog.procyon.org.uk>
Sender: linux-pm-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: dhowells@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-efi@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux PM <linux-pm@vger.kernel.org>, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, matthew.garrett@nebula.com
List-Id: linux-efi@vger.kernel.org

Rafael J. Wysocki <rafael@kernel.org> wrote:

> You probably want to disable hibernation altogether in this case.

See patch 10.  Does that mean patch 11 is superfluous?

David
