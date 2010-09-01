/*
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 *     http://dspace.org/license/
 */

package org.dspace.curate;

import java.io.IOException;

import org.dspace.content.DSpaceObject;
import org.dspace.core.Context;

/**
 * CurationTask describes a rather generic ability to perform an operation
 * upon a DSpace object.
 *
 * @author richardrodgers
 */
public interface CurationTask {

    /**
     * Initialize task - parameters inform the task of it's invoking curator.
     * Since the curator can provide services to the task, this represents
     * curation DI.
     * 
     * @param curator the Curator controlling this task
     * @param taskId identifier task should use in invoking services
     */
    public void init(Curator curator, String taskId);

    /**
     * Perform the curation task upon passed DSO
     *
     * @param dso the DSpace object
     * @throws IOException
     */
    public void perform(DSpaceObject dso) throws IOException;

    /**
     * Perform the curation task for passed id
     * 
     * @param ctx DSpace context object
     * @param id persistent ID for DSpace object
     * @throws Exception
     */
    public void perform(Context ctx, String id) throws IOException;
}
